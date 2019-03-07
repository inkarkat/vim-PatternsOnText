" PatternsOnText/Transactional/Expr.vim: Commands to apply substitutions through expressions either all or not at all.
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

let [s:previousPatternExpr, s:previousReplacementExpr, s:previousFlagsExpr, s:previousSpecialFlagsExpr] = ['', '', '', '']
function! PatternsOnText#Transactional#Expr#Substitute( range, arguments ) abort
    let [l:separator, s:previousPatternExpr, s:previousReplacementExpr, s:previousFlagsExpr, s:previousSpecialFlagsExpr, l:testExpr, l:updatePredicate] =
    \   PatternsOnText#Transactional#Common#ParseArguments(s:previousPatternExpr, s:previousReplacementExpr, s:previousFlagsExpr, s:previousSpecialFlagsExpr, a:arguments)

    try
	let l:patterns = PatternsOnText#EvalIntoList(s:previousPatternExpr)
	let l:replacementExpressions = PatternsOnText#EvalIntoList(s:previousReplacementExpr)

	return PatternsOnText#Transactional#Expr#TransactionalSubstitute(a:range, l:patterns, l:replacementExpressions, s:previousFlagsExpr, l:testExpr, l:updatePredicate)
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction
function! PatternsOnText#Transactional#Expr#TransactionalSubstitute( range, patterns, replacementExpressions, flags, testExpr, updatePredicate ) abort
    call ingo#err#Clear()

    let l:pattern = PatternsOnText#JoinPatterns(a:patterns)
    if empty(l:pattern) | return 0 | endif

    let l:matches = []
    let s:SubstituteTransactional = PatternsOnText#InitialContext()
    let l:hasValReferenceInExpr = (a:testExpr =~# ingo#actions#GetValExpr())

    try
	execute printf('%ssubstitute/%s/\=s:RecordExpression(l:matches, %d, a:testExpr, %d)/%s',
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

	for l:match in reverse(l:matches)
	    let l:replacement = get(a:replacementExpressions, l:match[3], get(a:replacementExpressions, -1, ''))  " Lookup corresponding replacement based on the matched patternIndex, stored with PatternsOnText#Transactional#Common#Record().
	    let l:isReplacementExpression = (l:replacement =~# '^\\=')
	    let l:hasValReferenceInReplacement = (l:isReplacementExpression && l:replacement =~# ingo#actions#GetValExpr())
	    let l:replacement = (l:hasValReferenceInReplacement ?
	    \   substitute(l:replacement, '\C' . ingo#actions#GetValExpr(), 'PatternsOnText#Transactional#Expr#GetContext()', 'g') :
	    \   l:replacement
	    \)

	    if l:isReplacementExpression
		" Position the cursor on the beginning of the match.
		call call('cursor', l:match[0])
	    endif

	    call PatternsOnText#Transactional#Common#Substitute(s:SubstituteTransactional, l:match, l:replacement)
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
function! PatternsOnText#Transactional#Expr#GetContext() abort
    return s:SubstituteTransactional
endfunction
function! s:RecordExpression( matches, patternNum, testExpr, hasValReferenceInExpr ) abort
    for l:i in range(a:patternNum)
	if ! empty(submatch(l:i + 1))
	    let s:SubstituteTransactional.patternIndex = l:i
	    return PatternsOnText#Transactional#Common#Record(s:SubstituteTransactional, a:matches, a:testExpr, a:hasValReferenceInExpr, l:i)
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
