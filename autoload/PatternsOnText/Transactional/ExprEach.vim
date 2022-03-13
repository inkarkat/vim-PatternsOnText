" PatternsOnText/Transactional/ExprEach.vim: Commands to apply substitutions through expressions with separate matches either all or not at all.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2019-2022 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

let [s:previousPatternExpr, s:previousReplacementExpr, s:previousFlagsExpr, s:previousSpecialFlagsExpr] = ['', '', '', '']
function! PatternsOnText#Transactional#ExprEach#Substitute( mods, range, arguments ) abort
    let [l:separator, s:previousPatternExpr, s:previousReplacementExpr, s:previousFlagsExpr, s:previousSpecialFlagsExpr, l:testExpr, l:updatePredicate] =
    \   PatternsOnText#Transactional#Common#ParseArguments(s:previousPatternExpr, s:previousReplacementExpr, s:previousFlagsExpr, s:previousSpecialFlagsExpr, a:arguments)

    try
	let l:patterns = PatternsOnText#EvalIntoList(s:previousPatternExpr)
	let l:replacementExpressions = PatternsOnText#EvalIntoList(s:previousReplacementExpr)

	return PatternsOnText#Transactional#ExprEach#TransactionalSubstitute(a:mods, a:range, l:patterns, l:replacementExpressions, s:previousFlagsExpr, l:testExpr, l:updatePredicate)
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction
function! PatternsOnText#Transactional#ExprEach#TransactionalSubstitute( mods, range, patterns, replacementExpressions, flags, testExpr, updatePredicate ) abort
    call ingo#err#Clear()
    if empty(a:patterns)
	call ingo#err#Set('No patterns')
	return 0
    endif

    let l:matches = []
    let s:SubstituteTransactional = PatternsOnText#Transactional#Common#InitialContext()
    let l:hasValReferenceInExpr = (a:testExpr =~# ingo#actions#GetValExpr())

    try
	for l:i in range(len(a:patterns))
	    let s:SubstituteTransactional.patternIndex = l:i
	    execute printf('%s %ssubstitute/%s/\=PatternsOnText#Transactional#Common#Record(s:SubstituteTransactional, l:matches, a:testExpr, %d, -1, %d)/%s',
	    \   a:mods, a:range, escape(a:patterns[l:i], '/'), l:hasValReferenceInExpr, l:i, a:flags
	    \)
	endfor

	if has_key(s:SubstituteTransactional, 'error')
	    call ingo#err#Set(s:SubstituteTransactional.error)
	    return 0
	endif
	let s:SubstituteTransactional.matchNum = s:SubstituteTransactional.matchCount

	if ! empty(a:updatePredicate) && ! ingo#actions#EvaluateWithVal(a:updatePredicate, s:SubstituteTransactional)
	    call ingo#err#Set('Substitution aborted by update predicate')
	    return 0
	endif

	for l:match in sort(l:matches, function('PatternsOnText#Transactional#ExprEach#SortByPosition'))
	    let l:replacement = get(a:replacementExpressions, l:match[4], get(a:replacementExpressions, -1, ''))  " Lookup corresponding replacement based on the matched patternIndex, stored with PatternsOnText#Transactional#Common#Record().
	    let [l:isReplacementExpression, l:replacement] = PatternsOnText#Transactional#Common#ProcessReplacementExpression(l:replacement, 'PatternsOnText#Transactional#ExprEach#GetContext()')

	    if l:isReplacementExpression
		" Position the cursor on the beginning of the match.
		call call('cursor', l:match[0])
	    endif

	    call PatternsOnText#Transactional#Common#Substitute(s:SubstituteTransactional, l:match, l:replacement, ['', 'patternIndex'])
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
	unlet! s:SubstituteTransactional
    endtry
endfunction
function! PatternsOnText#Transactional#ExprEach#GetContext() abort
    return s:SubstituteTransactional
endfunction
function! PatternsOnText#Transactional#ExprEach#SortByPosition( m1, m2 ) abort
    " Areas at the end come before previous ones. If one area is inside another,
    " the larger one (i.e. the one that extends further to the end) comes first.
    " So, we need to compare based on the end position. If multiple areas end at
    " the same position, start with the smallest one.
    let [l:endPos1, l:endPos2] = [a:m1[1], a:m2[1]]

    if l:endPos1 !=# l:endPos2
	return (ingo#pos#IsBefore(l:endPos1, l:endPos2) ? 1 : -1)
    endif

    let [l:startPos1, l:startPos2] = [a:m1[0], a:m2[0]]
    if l:startPos1 != l:startPos2
	return (ingo#pos#IsBefore(l:startPos1, l:startPos2) ? 1 : -1)
    endif

    " Same area: Last patternIndex first.
    let [l:idx1, l:idx2] = [get(a:m1, 3, -1), get(a:m2, 3, -1)]
    return (l:idx1 == l:idx2 ? 0 : l:idx1 > l:idx2 ? 1 : -1)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
