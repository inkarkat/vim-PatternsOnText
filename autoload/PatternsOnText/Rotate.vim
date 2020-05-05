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
function! PatternsOnText#Rotate#Substitute( range, arguments ) abort
    let [l:separator, l:pattern, l:replacement, s:previousFlags, s:previousSpecialFlags, l:testExpr, l:updatePredicate] = PatternsOnText#Transactional#Common#ParseArguments(s:previousPattern, '', s:previousFlags, s:previousSpecialFlags, a:arguments)
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

    let l:rotatingReplacementExpression = (s:previousShiftValue is# s:NO_SHIFT_VALUE ?
    \   '\=PatternsOnText#Rotate#RotateExpr(v:val)' :
    \   '\=PatternsOnText#Rotate#ShiftExpr(v:val)'
    \)

    let s:SubstituteRotate = PatternsOnText#Transactional#Common#InitialContext()
    try
	return PatternsOnText#Transactional#TransactionalSubstituteWithContext(
	\   function('PatternsOnText#Rotate#GetContext'),
	\   a:range, l:unescapedPattern, l:rotatingReplacementExpression, s:previousFlags, l:testExpr, l:updatePredicate
	\)
    finally
	unlet! s:SubstituteRotate
    endtry
endfunction

function! PatternsOnText#Rotate#RotateExpr( context ) abort
    return a:context.matches[(((a:context.matchCount - s:previousOffset - 1) % a:context.matchNum) + a:context.matchNum) % a:context.matchNum + 1]
endfunction
function! PatternsOnText#Rotate#ShiftExpr( context ) abort
    let l:index = a:context.matchCount - s:previousOffset
    if l:index < 1 || l:index > a:context.matchNum
	if s:previousShiftValue =~# '^\\='
	    let [l:isReplacementExpression, l:replacementExpression] = PatternsOnText#Transactional#Common#ProcessReplacementExpression(s:previousShiftValue, 'PatternsOnText#Rotate#GetContext()')
	    return eval(l:replacementExpression[2:])
	else
	    return s:previousShiftValue
	endif
    else
	return a:context.matches[l:index]
    endif
endfunction
function! PatternsOnText#Rotate#GetContext() abort
    return s:SubstituteRotate
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
