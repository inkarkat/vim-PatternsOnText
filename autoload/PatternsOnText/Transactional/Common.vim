" Common.vim: Common functionality for transactional substitutions.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
let s:save_cpo = &cpo
set cpo&vim

let s:special = 'tu'
function! s:GetFlagsExpr( captureGroupCnt ) abort
    return '\(' . ingo#cmdargs#substitute#GetFlags() . '\)\(\%(\s*[' . s:special . ']' . ingo#cmdargs#pattern#PatternExpr(a:captureGroupCnt) . '\)*\)'
endfunction
function! PatternsOnText#Transactional#Common#ParseArguments( previousPattern, previousReplacement, previousFlags, previousSpecialFlags, arguments ) abort
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

function! PatternsOnText#Transactional#Common#ProcessReplacementExpression( replacement, accessor ) abort
    let l:isReplacementExpression = (a:replacement =~# '^\\=')
    let l:hasValReferenceInReplacement = (l:isReplacementExpression && a:replacement =~# ingo#actions#GetValExpr())
    return [l:isReplacementExpression, (l:hasValReferenceInReplacement ?
    \   substitute(a:replacement, '\C' . ingo#actions#GetValExpr(), a:accessor, 'g') :
    \   a:replacement
    \)]
endfunction

function! PatternsOnText#Transactional#Common#Record( context, matches, testExpr, hasValReferenceInExpr, ... ) abort
    let l:matchText = submatch(a:0 ? a:1 + 1 : 0)
    if has_key(a:context, 'error')
	" Short-circuit all further errors; printing the expression error once is
	" enough.
	return l:matchText
    endif

    let a:context.matchCount += 1
    let l:record = (empty(l:matchText) ?
    \   repeat([getpos('.')[1:2]], 2) :
    \   ingo#area#frompattern#GetHere('\C\V' . substitute(escape(l:matchText, '\'), '\n', '\\n', 'g'), line('.'), [])
    \)
    if empty(l:record)
	let a:context.error = printf('Failed to capture match #%d at %s: %s', a:context.matchCount, string(getpos('.')[1:2]), l:matchText)
	return l:matchText
    endif

    try
	if ! empty(a:testExpr)
	    let l:expr = (a:hasValReferenceInExpr ?
	    \   substitute(a:testExpr, '\C' . ingo#actions#GetValExpr(), 'a:context', 'g') :
	    \   a:testExpr
	    \)
	    execute l:expr
	endif

	call add(l:record, l:matchText)
	call add(a:matches, l:record + a:000)
    catch /^skip$/
	let a:context.matchCount -= 1
    catch /^Vim\%((\a\+)\)\=:/
	let a:context.error = ingo#msg#MsgFromVimException()
    catch
	let a:context.error = 'Expression threw exception: ' . v:exception
    finally
	return l:matchText
    endtry
endfunction

function! PatternsOnText#Transactional#Common#Substitute( context, match, replacement ) abort
    let [l:startPos, l:endPos, l:matchText] = a:match[0:2]

    " Update the context object with the current match information.
    let a:context.matchText = l:matchText
    let a:context.startPos = l:startPos
    let a:context.endPos = l:endPos
    if len(a:match) >= 4
	let a:context.patternIndex = a:match[3]
    endif

    let l:result = ingo#subst#replacement#ReplaceSpecial(l:matchText, a:replacement, '&', function('PatternsOnText#ReplaceSpecial'))

    if l:result !=# l:matchText
	call ingo#text#replace#Between(l:startPos, l:endPos, l:result)[2]

	let a:context.lastLnum = max([a:context.lastLnum, l:endPos[0]])
    endif

    let a:context.matchCount -= 1
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
