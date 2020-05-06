" PatternsOnText/Rotate.vim: Commands to rotate the matches as preceding / following replacements.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

let s:NO_SHIFT_VALUE = []
let [s:previousPattern, s:previousShiftValue, s:previousOffset, s:previousFlags, s:previousSpecialFlags] = ['', s:NO_SHIFT_VALUE, 0, '', '']
function! s:Substitute( shiftExpr, rotateExpr, range, arguments ) abort
    let [l:separator, l:pattern, l:replacement, s:previousFlags, s:previousSpecialFlags, l:testExpr, l:updatePredicate] =
    \   PatternsOnText#Transactional#Common#ParseArguments(s:previousPattern, '', s:previousFlags, s:previousSpecialFlags, a:arguments)
    let l:unescapedPattern = ingo#escape#Unescape(l:pattern, l:separator)
    let s:previousPattern = escape(l:unescapedPattern, '/')
    if ! empty(l:replacement)
	let l:parse = matchlist(l:replacement, '^\(\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!' . escape(l:separator, '\') . '\)\?\([+-]\?\d\+\)$')
	if empty(l:parse)
	    call ingo#err#Set('Missing [/{shift-value}]/[+-]N/')
	    return 0
	endif
	let s:previousShiftValue = (empty(l:parse[1]) ? s:NO_SHIFT_VALUE : l:parse[2])
	let s:previousOffset = str2nr(l:parse[3])
    endif
    if empty(s:previousOffset)
	call ingo#err#Set('Missing [/{shift-value}]/[+-]N/')
	return 0
    endif

    let l:isShift = (s:previousShiftValue isnot# s:NO_SHIFT_VALUE)
    let l:rotatingReplacementExpression = '\=' . (l:isShift ? a:shiftExpr : a:rotateExpr) . '(v:val)'

    let s:SubstituteRotate = PatternsOnText#Transactional#Common#InitialContext()
    try
	let l:success = PatternsOnText#Transactional#TransactionalSubstituteWithContext(
	\   function('PatternsOnText#Rotate#GetContext'),
	\   a:range, l:unescapedPattern, l:rotatingReplacementExpression, s:previousFlags, l:testExpr, l:updatePredicate
	\)

	if l:isShift && s:previousOffset != 0
	    let l:missedMatches = (s:previousOffset > 0 ?
	    \   s:SubstituteRotate.matches[max([1, len(s:SubstituteRotate.matches) - s:previousOffset]):] :
	    \   s:SubstituteRotate.matches[1:(-1 * s:previousOffset)]
	    \)
	    call setreg('', join(l:missedMatches, "\n") . (len(l:missedMatches) > 1 ? "\n" : ''))
	endif

	return l:success
    finally
	unlet! s:SubstituteRotate
    endtry
endfunction
function! PatternsOnText#Rotate#GetContext() abort
    return s:SubstituteRotate
endfunction
function! s:RotateExpr( count, num, context ) abort
    return (((a:count - s:previousOffset - 1) % a:num) + a:num) % a:num + 1
endfunction
function! s:ShiftExpr( count, num, context ) abort
    let l:index = a:count - s:previousOffset
    if l:index < 1 || l:index > a:num
	if s:previousShiftValue =~# '^\\='
	    let [l:isReplacementExpression, l:replacementExpression] =
	    \   PatternsOnText#Transactional#Common#ProcessReplacementExpression(s:previousShiftValue, 'PatternsOnText#Rotate#GetContext()')
	    return [0, eval(l:replacementExpression[2:])]
	else
	    return [0, s:previousShiftValue]
	endif
    else
	return [1, a:context.matches[l:index]]
    endif
endfunction

function! PatternsOnText#Rotate#Substitute( range, arguments ) abort
    return s:Substitute(
    \   'PatternsOnText#Rotate#ShiftExpr',
    \   'PatternsOnText#Rotate#RotateExpr',
    \   a:range, a:arguments
    \)
endfunction
function! PatternsOnText#Rotate#RotateExpr( context ) abort
    return a:context.matches[s:RotateExpr(a:context.matchCount, a:context.matchNum, a:context)]
endfunction
function! PatternsOnText#Rotate#ShiftExpr( context ) abort
    return s:ShiftExpr(a:context.matchCount, a:context.matchNum, a:context)[1]
endfunction

function! PatternsOnText#Rotate#SubstituteMemoized( range, isClearAssociations, arguments ) abort
    let s:uniqueMatches = []
    let l:status = s:Substitute(
    \   'PatternsOnText#Rotate#MemoizedShiftExpr',
    \   'PatternsOnText#Rotate#MemoizedRotateExpr',
    \   a:range, a:arguments
    \)
    unlet! s:uniqueMatches
    return l:status
endfunction
function! s:InitializeUniqueMatches( context ) abort
    if empty(s:uniqueMatches)
	let s:uniqueMatches = [''] + ingo#collections#UniqueStable(a:context.matches[1:])
    endif
endfunction
function! PatternsOnText#Rotate#MemoizedRotateExpr( context ) abort
    call s:InitializeUniqueMatches(a:context)
    return s:uniqueMatches[s:RotateExpr(index(s:uniqueMatches, a:context.matchText), len(s:uniqueMatches) - 1, a:context)]
endfunction
function! PatternsOnText#Rotate#MemoizedShiftExpr( context ) abort
    call s:InitializeUniqueMatches(a:context)
    let l:count = index(s:uniqueMatches, a:context.matchText)

    let [l:isFound, l:value] = s:ShiftExpr(l:count, len(s:uniqueMatches) - 1, a:context)
    return (l:isFound ? a:context.matches[index(a:context.matches, a:context.matchText) - s:previousOffset] : l:value)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
