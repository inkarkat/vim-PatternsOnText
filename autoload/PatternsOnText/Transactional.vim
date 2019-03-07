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
    let [l:separator, l:pattern, l:replacement, s:previousFlags, s:previousSpecialFlags, l:testExpr, l:updatePredicate] = PatternsOnText#Transactional#ParseArguments(s:previousPattern, s:previousReplacement, s:previousFlags, s:previousSpecialFlags, a:arguments)
    let l:unescapedPattern = ingo#escape#Unescape(l:pattern, l:separator)
    let l:unescapedReplacement = ingo#escape#Unescape(l:replacement, l:separator)
    let [s:previousPattern, s:previousReplacement] = [escape(l:unescapedPattern, '/'), escape(l:unescapedReplacement, '/')]

    return PatternsOnText#Transactional#TransactionalSubstitute(a:range, l:unescapedPattern, l:unescapedReplacement, s:previousFlags, l:testExpr, l:updatePredicate)
endfunction
function! PatternsOnText#Transactional#TransactionalSubstitute( range, pattern, replacement, flags, testExpr, updatePredicate ) abort
    call ingo#err#Clear()
    let s:testExpr = a:testExpr
    let s:matches = []
    let s:SubstituteTransactional = PatternsOnText#InitialContext()
    let l:hasValReferenceInExpr = (s:testExpr =~# ingo#actions#GetValExpr())

    try
	execute printf('%ssubstitute/%s/\=s:Record(%d)/%s',
	\   a:range, escape(a:pattern, '/'), l:hasValReferenceInExpr, a:flags
	\)

	if has_key(s:SubstituteTransactional, 'error')
	    call ingo#err#Set(s:SubstituteTransactional.error)
	    return 0
	endif
	let s:SubstituteTransactional.matchNum = s:SubstituteTransactional.matchCount

	if ! empty(a:updatePredicate) && ! ingo#actions#EvaluateWithVal(a:updatePredicate, s:SubstituteTransactional)
	    call ingo#err#Set('Substitution aborted by update predicate')
	    return 0
	endif

	let l:isReplacementExpression = (a:replacement =~# '^\\=')
	let l:hasValReferenceInReplacement = (l:isReplacementExpression && a:replacement =~# ingo#actions#GetValExpr())
	let l:replacement = (l:hasValReferenceInReplacement ?
	\   substitute(a:replacement, '\C' . ingo#actions#GetValExpr(), 'PatternsOnText#Transactional#GetContext()', 'g') :
	\   a:replacement
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
function! s:Record( hasValReferenceInExpr, ... ) abort
    let l:matchText = submatch(a:0 ? a:1 + 1 : 0)
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
	call add(s:matches, l:record + a:000)
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
    let [l:startPos, l:endPos, l:matchText] = a:match[0:2]

    " Update the context object with the current match information.
    let s:SubstituteTransactional.matchText = l:matchText
    let s:SubstituteTransactional.startPos = l:startPos
    let s:SubstituteTransactional.endPos = l:endPos
    if len(a:match) >= 4
	let s:SubstituteTransactional.patternIndex = a:match[3]
    endif

    let l:result = ingo#subst#replacement#ReplaceSpecial(l:matchText, a:replacement, '&', function('PatternsOnText#ReplaceSpecial'))

    if l:result !=# l:matchText
	call ingo#text#replace#Between(l:startPos, l:endPos, l:result)[2]

	let s:SubstituteTransactional.lastLnum = max([s:SubstituteTransactional.lastLnum, l:endPos[0]])
    endif

    let s:SubstituteTransactional.matchCount -= 1
endfunction
function! PatternsOnText#Transactional#GetContext() abort
    return s:SubstituteTransactional
endfunction



let [s:previousPatternExpr, s:previousReplacementExpr, s:previousFlagsExpr, s:previousSpecialFlagsExpr] = ['', '', '', '']
function! PatternsOnText#Transactional#SubstituteExpr( range, arguments ) abort
    let [l:separator, s:previousPatternExpr, s:previousReplacementExpr, s:previousFlagsExpr, s:previousSpecialFlagsExpr, l:testExpr, l:updatePredicate] =
    \   PatternsOnText#Transactional#ParseArguments(s:previousPatternExpr, s:previousReplacementExpr, s:previousFlagsExpr, s:previousSpecialFlagsExpr, a:arguments)

    try
	let l:patterns = PatternsOnText#EvalIntoList(s:previousPatternExpr)
	let l:replacementExpressions = PatternsOnText#EvalIntoList(s:previousReplacementExpr)

	return PatternsOnText#Transactional#TransactionalSubstituteExpr(a:range, l:patterns, l:replacementExpressions, s:previousFlagsExpr, l:testExpr, l:updatePredicate)
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction
function! PatternsOnText#Transactional#TransactionalSubstituteExpr( range, patterns, replacementExpressions, flags, testExpr, updatePredicate ) abort
    call ingo#err#Clear()

    " Check for forbidden capture groups.
    for l:i in range(len(a:patterns))
	if PatternsOnText#IsContainsCaptureGroup(a:patterns[l:i])
	    call ingo#err#Set(printf('Capture groups not allowed in pattern #%d: %s', l:i + 1, a:patterns[l:i]))
	    return 0
	endif
    endfor

    if empty(a:patterns)
	call ingo#err#Set('No patterns')
	return 0
    endif

    " Remove any atoms changing the magicness, then surround each individual
    " match with a capturing group, so that we can determine which branch
    " matched (and use the corresponding replacement).
    let l:pattern = join(
    \  map(
    \      copy(a:patterns),
    \      '"\\(" . escape(ingo#regexp#magic#Normalize(v:val), "/") . "\\)"'
    \  ),
    \  '\|'
    \)

    let s:testExpr = a:testExpr
    let s:matches = []
    let s:SubstituteTransactional = PatternsOnText#InitialContext()
    let l:hasValReferenceInExpr = (s:testExpr =~# ingo#actions#GetValExpr())

    try
	execute printf('%ssubstitute/%s/\=s:RecordExpression(%d, %d)/%s',
	\   a:range, escape(l:pattern, '/'), len(a:patterns), l:hasValReferenceInExpr, a:flags
	\)

	if has_key(s:SubstituteTransactional, 'error')
	    call ingo#err#Set(s:SubstituteTransactional.error)
	    return 0
	endif
	let s:SubstituteTransactional.matchNum = s:SubstituteTransactional.matchCount

	if ! empty(a:updatePredicate) && ! ingo#actions#EvaluateWithVal(a:updatePredicate, s:SubstituteTransactional)
	    call ingo#err#Set('Substitution aborted by update predicate')
	    return 0
	endif

	for l:match in reverse(s:matches)
	    let l:replacement = get(a:replacementExpressions, l:match[3], get(a:replacementExpressions, -1, ''))  " Lookup corresponding replacement based on the matched patternIndex, stored with s:Record().
	    let l:isReplacementExpression = (l:replacement =~# '^\\=')
	    let l:hasValReferenceInReplacement = (l:isReplacementExpression && l:replacement =~# ingo#actions#GetValExpr())
	    let l:replacement = (l:hasValReferenceInReplacement ?
	    \   substitute(l:replacement, '\C' . ingo#actions#GetValExpr(), 'PatternsOnText#Transactional#GetContext()', 'g') :
	    \   l:replacement
	    \)

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
function! s:RecordExpression( patternNum, hasValReferenceInExpr ) abort
    for l:i in range(a:patternNum)
	if ! empty(submatch(l:i + 1))
	    let s:SubstituteTransactional.patternIndex = l:i
	    return s:Record(a:hasValReferenceInExpr, l:i)
	endif
    endfor

    " Should never happen; one branch always matches, and branches shouldn't be
    " empty.
    let s:SubstituteTransactional.error = 'Could not locate matching pattern'
    return submatch(0)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
