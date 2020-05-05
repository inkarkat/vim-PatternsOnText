" PatternsOnText/Transactional.vim: Commands to apply substitutions either all or not at all.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2019-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

let [s:previousPattern, s:previousReplacement, s:previousFlags, s:previousSpecialFlags] = ['', '', '', '']
function! PatternsOnText#Transactional#Substitute( range, arguments ) abort
    let [l:separator, l:pattern, l:replacement, s:previousFlags, s:previousSpecialFlags, l:testExpr, l:updatePredicate] =
    \   PatternsOnText#Transactional#Common#ParseArguments(s:previousPattern, s:previousReplacement, s:previousFlags, s:previousSpecialFlags, a:arguments)
    let l:unescapedPattern = ingo#escape#Unescape(l:pattern, l:separator)
    let l:unescapedReplacement = ingo#escape#Unescape(l:replacement, l:separator)
    let [s:previousPattern, s:previousReplacement] = [escape(l:unescapedPattern, '/'), escape(l:unescapedReplacement, '/')]

    return PatternsOnText#Transactional#TransactionalSubstitute(a:range, l:unescapedPattern, l:unescapedReplacement, s:previousFlags, l:testExpr, l:updatePredicate)
endfunction
function! PatternsOnText#Transactional#TransactionalSubstitute( range, pattern, replacement, flags, testExpr, updatePredicate ) abort
    let s:SubstituteTransactional = PatternsOnText#Transactional#Common#InitialContext()
    try
	return PatternsOnText#Transactional#TransactionalSubstituteWithContext(
	\   function('PatternsOnText#Transactional#GetContext'),
	\   a:range, a:pattern, a:replacement, a:flags, a:testExpr, a:updatePredicate
	\)
    finally
	unlet! s:SubstituteTransactional
    endtry
endfunction
function! PatternsOnText#Transactional#TransactionalSubstituteWithContext( ContextFunction, range, pattern, replacement, flags, testExpr, updatePredicate ) abort
    call ingo#err#Clear()
    let l:context = call(a:ContextFunction, [])
    let l:matches = []
    let l:hasValReferenceInExpr = (a:testExpr =~# ingo#actions#GetValExpr())

    try
	execute printf('%ssubstitute/%s/\=PatternsOnText#Transactional#Common#Record(l:context, l:matches, a:testExpr, %d)/%s',
	\   a:range, escape(a:pattern, '/'), l:hasValReferenceInExpr, a:flags
	\)

	if has_key(l:context, 'error')
	    call ingo#err#Set(l:context.error)
	    return 0
	endif
	let l:context.matchNum = l:context.matchCount

	if ! empty(a:updatePredicate) && ! ingo#actions#EvaluateWithVal(a:updatePredicate, l:context)
	    call ingo#err#Set('Substitution aborted by update predicate')
	    return 0
	endif

	let [l:isReplacementExpression, l:replacement] =
	\   PatternsOnText#Transactional#Common#ProcessReplacementExpression(a:replacement, ingo#funcref#ToString(a:ContextFunction).'()')
	" Note: The l:replacement is not handled within this script, so we need
	" to provide a global accessor for l:context that is in scope there.

	for l:match in reverse(l:matches)
	    if l:isReplacementExpression
		" Position the cursor on the beginning of the match.
		call call('cursor', l:match[0])
	    endif

	    call PatternsOnText#Transactional#Common#Substitute(l:context, l:match, l:replacement, [])
	endfor

	" :substitute has visited all further matches, but the last replacement
	" may have happened before that. Position the cursor on the last
	" actually selected match.
	execute l:context.lastLnum . 'normal! ^'

	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction
function! PatternsOnText#Transactional#GetContext() abort
    return s:SubstituteTransactional
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
