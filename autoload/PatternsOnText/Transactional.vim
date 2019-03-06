" PatternsOnText/Transactional.vim: Commands to apply substitutions either all or not at all.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

let s:special = 'tu'
function! s:GetFlagsExpr( captureGroupCnt ) abort
    return '\(' . ingo#cmdargs#substitute#GetFlags() . '\)\(\%(\s*[' . s:special . ']' . ingo#cmdargs#pattern#PatternExpr(a:captureGroupCnt) . '\)*\)'
endfunction
function! PatternsOnText#Transactional#ParseArguments( previousPattern, previousReplacement, previousFlags, previousSpecialFlags, arguments ) abort
    try
	let [l:separator, l:pattern, l:replacement, l:flags, l:specialFlags] =
	\   ingo#cmdargs#substitute#Parse(a:arguments, {'flagsExpr': s:GetFlagsExpr(6), 'flagsMatchCount': 2, 'emptyFlags': ['', ''], 'emptyPattern': a:previousPattern, 'emptyReplacement': a:previousReplacement, 'defaultReplacement': a:previousReplacement})
    catch /^Vim\%((\a\+)\)\=:E65:/ " E65: Illegal back reference
	" Special case of {flags} without /pat/string/. As we use back
	" references for the special flags, and ingo#cmdargs#substitute#Parse()
	" tests the flagsExpr separately in this case, it will fail, and we have
	" to do the parsing and defaulting on our own.
	let l:matches = matchlist(a:arguments, '\C^' . s:GetFlagsExpr(3) . '$')
	let [l:separator, l:pattern, l:replacement, l:flags, l:specialFlags] =
	\   ['/', a:previousPattern, a:previousReplacement, get(l:matches, 1, ''), get(l:matches, 2, '')]
    endtry
    if empty(l:pattern)
	let l:pattern = a:previousPattern
    endif

    if l:flags . l:specialFlags ==# a:arguments
	if empty(l:flags)
	    let l:flags = a:previousFlags
	endif
	if empty(l:flags)
	    let l:flags = '&'
	endif
	if empty(l:specialFlags)
	    let l:specialFlags = a:previousSpecialFlags
	endif
    endif

    return [l:separator, l:pattern, l:replacement, l:flags, l:specialFlags] + s:ParseSpecialFlags(l:specialFlags)
endfunction
function! s:ParseSpecialFlags( specialFlags ) abort
    let l:result = ['', '']
    let l:rest = a:specialFlags
    while 1
	let l:specialFlagsParse = matchlist(l:rest, '^\s*\([' . s:special . ']\)' . ingo#cmdargs#pattern#PatternExpr(2) . '\(.*\)$')
	if empty(l:specialFlagsParse)
	    break
	endif

	let l:specialIdx = stridx(s:special, l:specialFlagsParse[1])
	if l:specialIdx == -1 | throw 'ASSERT: Unexpected flag: ' . l:specialFlagsParse[1] | endif
	let l:result[l:specialIdx] = l:specialFlagsParse[3]
	let l:rest = l:specialFlagsParse[4]
    endwhile

    return l:result
endfunction

let [s:previousPattern, s:previousReplacement, s:previousFlags, s:previousSpecialFlags] = ['', '', '', '']
function! PatternsOnText#Transactional#Substitute( range, arguments ) abort
    call ingo#err#Clear()
    let [l:separator, l:pattern, l:replacement, l:flags, l:specialFlags, s:testExpr, l:updatePredicate] = PatternsOnText#Transactional#ParseArguments(s:previousPattern, s:previousReplacement, s:previousFlags, s:previousSpecialFlags, a:arguments)
    let l:unescapedPattern = ingo#escape#Unescape(l:pattern, l:separator)
    let l:unescapedReplacement = ingo#escape#Unescape(l:replacement, l:separator)
    let [s:previousPattern, s:previousReplacement, s:previousFlags, s:previousSpecialFlags] = [escape(l:unescapedPattern, '/'), escape(l:unescapedReplacement, '/'), l:flags, l:specialFlags]
    let s:matches = []
    let s:SubstituteTransactional = PatternsOnText#InitialContext()
    let l:hasValReferenceInExpr = (s:testExpr =~# ingo#actions#GetValExpr())

    try
	execute printf('%ssubstitute/%s/\=s:Record(%d)/%s',
	\   a:range, escape(l:unescapedPattern, '/'), l:hasValReferenceInExpr, l:flags
	\)

	if has_key(s:SubstituteTransactional, 'error')
	    call ingo#err#Set(s:SubstituteTransactional.error)
	    return 0
	endif

	if ! empty(l:updatePredicate) && ! ingo#actions#EvaluateWithVal(l:updatePredicate, s:SubstituteTransactional)
	    call ingo#err#Set('Substitution aborted by update predicate')
	    return 0
	endif

	let l:isReplacementExpression = (l:unescapedReplacement =~# '^\\=')
	let l:hasValReferenceInReplacement = (l:isReplacementExpression && l:unescapedReplacement =~# ingo#actions#GetValExpr())
	let l:replacement = (l:hasValReferenceInReplacement ?
	\   substitute(l:unescapedReplacement, '\C' . ingo#actions#GetValExpr(), 'PatternsOnText#Transactional#GetContext()', 'g') :
	\   l:unescapedReplacement
	\)
	" Note: The l:replacement is not handled within this script, so we need
	" to provide a global PatternsOnText#Transactional#GetContext() accessor
	" for s:SubstituteTransactional that is in scope there.

	for l:match in reverse(s:matches)
	    if l:isReplacementExpression
		" Position the cursor on the beginning of the match.
		call call('cursor', l:match[0])
	    endif

	    call s:Substitute(l:match, l:replacement)
	endfor

	" :substitute has visited all further matches, but the last replacement
	" may have happened before that. Position the cursor on the last
	" actually selected match.
	execute s:SubstituteTransactional.lastLnum . 'normal! ^'

	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    finally
	unlet! s:testExpr s:matches s:SubstituteTransactional
    endtry
endfunction
function! s:Record( hasValReferenceInExpr ) abort
    let l:matchText = submatch(0)
    if has_key(s:SubstituteTransactional, 'error')
	" Short-circuit all further errors; printing the expression error once is
	" enough.
	return l:matchText
    endif

    let s:SubstituteTransactional.matchCount += 1
    let l:record = (empty(l:matchText) ?
    \   repeat([getpos('.')[1:2]], 2) :
    \   ingo#area#frompattern#GetHere('\C\V' . substitute(escape(l:matchText, '\'), '\n', '\\n', 'g'), line('.'), [])
    \)
    if empty(l:record)
	let s:SubstituteTransactional.error = printf('Failed to capture match #%d at %s: %s', s:SubstituteTransactional.matchCount, string(getpos('.')[1:2]), l:matchText)
	return l:matchText
    endif

    try
	if ! empty(s:testExpr)
	    let l:expr = (a:hasValReferenceInExpr ?
	    \   substitute(s:testExpr, '\C' . ingo#actions#GetValExpr(), 's:SubstituteTransactional', 'g') :
	    \   s:testExpr
	    \)
	    execute l:expr
	endif

	call add(l:record, l:matchText)
	call add(s:matches, l:record)
    catch /^skip$/
	let s:SubstituteTransactional.matchCount -= 1
    catch /^Vim\%((\a\+)\)\=:/
	let s:SubstituteTransactional.error = ingo#msg#MsgFromVimException()
    catch
	let s:SubstituteTransactional.error = 'Expression threw exception: ' . v:exception
    finally
	return l:matchText
    endtry
endfunction
function! s:Substitute( match, replacement ) abort
    let [l:startPos, l:endPos, l:matchText] = a:match
    let l:result = ingo#subst#replacement#ReplaceSpecial(l:matchText, a:replacement, '&', function('PatternsOnText#ReplaceSpecial'))

    if l:result !=# l:matchText
	call ingo#text#replace#Between(l:startPos, l:endPos, l:result)[2]

	if ! has_key(s:SubstituteTransactional, 'lastLnum')
	    " As we're iterating from last match to first, we just need to set the
	    " value once.
	    let s:SubstituteTransactional.lastLnum = l:endPos[0]
	endif
    endif
endfunction
function! PatternsOnText#Transactional#GetContext() abort
    return s:SubstituteTransactional
endfunction

function! PatternsOnText#Transactional#SubstituteExpr( range, arguments ) abort
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
