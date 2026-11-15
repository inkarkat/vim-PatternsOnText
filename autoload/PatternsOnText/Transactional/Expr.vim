" PatternsOnText/Transactional/Expr.vim: Commands to apply substitutions through expressions either all or not at all.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2019-2026 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

let [s:previousPatternExpr, s:previousReplacementExpr, s:previousFlagsExpr, s:previousSpecialFlagsExpr] = ['', '', '', '']
function! PatternsOnText#Transactional#Expr#Substitute( mods, range, arguments ) abort
    let [l:separator, s:previousPatternExpr, s:previousReplacementExpr, s:previousFlagsExpr, s:previousSpecialFlagsExpr, l:testExpr, l:updatePredicate] =
    \   PatternsOnText#Transactional#Common#ParseArguments(s:previousPatternExpr, s:previousReplacementExpr, s:previousFlagsExpr, s:previousSpecialFlagsExpr, a:arguments)

    try
	let l:patterns = PatternsOnText#EvalIntoList(s:previousPatternExpr)
	let l:replacementExpressions = PatternsOnText#EvalIntoList(s:previousReplacementExpr)

	return PatternsOnText#Transactional#Expr#TransactionalSubstitute(a:mods, a:range, l:patterns, l:replacementExpressions, s:previousFlagsExpr, l:testExpr, l:updatePredicate)
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction
function! PatternsOnText#Transactional#Expr#TransactionalSubstitute( mods, range, patterns, replacementExpressions, flags, testExpr, updatePredicate ) abort
    call ingo#err#Clear()

    let l:substitutor = PatternsOnText#JoinPatterns(a:patterns, '/', 'ingo#regexp#magic#Normalize(v:val)')
    if empty(l:substitutor) | return 0 | endif

    let l:matches = []
    let s:SubstituteTransactional = PatternsOnText#Transactional#Common#InitialContext()
    let l:hasValReferenceInExpr = (a:testExpr =~# ingo#actions#GetValExpr())

    try
	execute printf('%s %ssubstitute/%s/\=s:RecordExpression(l:substitutor.getPatternIndexAndMatch()[0], l:matches, a:testExpr, %d)/%s',
	\   a:mods, a:range, l:substitutor.pattern, l:hasValReferenceInExpr, a:flags
	\)

	let s:SubstituteTransactional.matchNum = s:SubstituteTransactional.matchCount

	if ! empty(a:updatePredicate) && ! ingo#actions#EvaluateWithVal(a:updatePredicate, s:SubstituteTransactional)
	    call ingo#err#Set('Substitution aborted by update predicate')
	    return 0
	endif

	for l:match in reverse(l:matches)
	    let l:replacement = get(a:replacementExpressions, l:match[3], get(a:replacementExpressions, -1, ''))  " Lookup corresponding replacement based on the matched patternIndex, stored with PatternsOnText#Transactional#Common#Record().
	    let [l:isReplacementExpression, l:replacement] = PatternsOnText#Transactional#Common#ProcessReplacementExpression(l:replacement, 'PatternsOnText#Transactional#Expr#GetContext()')

	    if l:isReplacementExpression
		" Position the cursor on the beginning of the match.
		call call('cursor', l:match[0])
	    endif

	    call PatternsOnText#Transactional#Common#Substitute(s:SubstituteTransactional, l:match, l:replacement, ['patternIndex'])
	endfor

	" :substitute has visited all further matches, but the last replacement
	" may have happened before that. Position the cursor on the last
	" actually selected match.
	execute s:SubstituteTransactional.lastLnum . 'normal! ^'

	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    catch /^PatternsOnText:/
	call ingo#err#SetCustomException('PatternsOnText')
	return 0
    finally
	unlet! s:SubstituteTransactional
    endtry
endfunction
function! PatternsOnText#Transactional#Expr#GetContext() abort
    return s:SubstituteTransactional
endfunction
function! s:RecordExpression( patternIndex, matches, testExpr, hasValReferenceInExpr ) abort
    let s:SubstituteTransactional.patternIndex = a:patternIndex
    return PatternsOnText#Transactional#Common#Record(s:SubstituteTransactional, a:matches, a:testExpr, a:hasValReferenceInExpr, a:patternIndex)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
