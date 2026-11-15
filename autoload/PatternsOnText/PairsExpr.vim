" PatternsOnText/PairsExpr.vim: Commands to apply multiple pattern-replace pairs through expressions.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2014-2026 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! s:ParseExprAndFlagsAndCount( arguments, ... ) abort
    let l:expr = a:arguments
    let l:count = ''
    let l:flags = ''
    let l:parse = matchlist(l:expr, '^\(.*\)\s\+\(\d\+\)$')
    if ! empty(l:parse)
	let [l:expr, l:count] = l:parse[1:2]
    endif
    let l:parse = matchlist(l:expr, '^\(.*\)\s\+\(' . call(function('ingo#cmdargs#substitute#GetFlags'), a:000) . '\d*\)$')
    if ! empty(l:parse)
	let [l:expr, l:flags] = l:parse[1:2]
    endif

    return [l:expr, l:flags, l:count]
endfunction
function! s:IsPair( expr ) abort
    return (type(a:expr) == type([])
    \   && len(a:expr) == 2
    \   && ! ingo#collections#IsCollection(a:expr[0])
    \   && ! ingo#collections#IsCollection(a:expr[1])
    \)
endfunction
let [s:previousExpr, s:previousExprFlags, s:previousExprCount] = ['', '', '']
function! PatternsOnText#PairsExpr#SubstituteExpr( mods, range, arguments )
    let [l:expr, l:flags, l:count] = s:ParseExprAndFlagsAndCount(a:arguments, 'PwWLER')

    if empty(l:expr)
	let l:expr = s:previousExpr
    endif
    if l:flags . l:count ==# a:arguments
	if empty(l:flags)
	    let l:flags = s:previousExprFlags
	endif
	if empty(l:flags)
	    let l:flags = '&'
	endif
	if empty(l:count)
	    let l:count = s:previousExprCount
	endif
    endif
    if empty(l:expr)
	call ingo#err#Set('No expression')
	return 0
    endif

    try
	let l:result = eval(l:expr)
	if type(l:result) == type({})
	    let l:exprItems = items(l:result)
	elseif type(l:result) == type([])
	    if s:IsPair(l:result)
		let l:exprItems = [l:result]
	    else
		for l:item in l:result
		    if ! s:IsPair(l:item)
			call ingo#err#Set('Not a [pattern, replacement] pair: ' . string(l:item))
			return 0
		    endif
		endfor

		let l:exprItems = l:result
	    endif
	else
	    call ingo#err#Set('Expression needs to be {pattern: replacement} or [[pattern, replacement], ...]')
	    return 0
	endif

	let s:previousExpr = l:expr
	let l:patterns = map(copy(l:exprItems), 'v:val[0]')
	let l:replacements = map(copy(l:exprItems), 'v:val[1]')
	let s:previousExprFlags = l:flags
	let s:previousExprCount = l:count

	return PatternsOnText#PairsExpr#DoSubstitute(a:mods, a:range, l:patterns, l:replacements, l:flags, l:count)
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    catch /^PatternsOnText:/
	call ingo#err#SetCustomException('PatternsOnText')
	return 0
    endtry
endfunction



let [s:previousPatternExpr, s:previousReplacementExpr, s:previousMultipleExprFlags, s:previousMultipleExprCount] = ['', '', '', '']
function! PatternsOnText#PairsExpr#SubstituteMultipleExpr( mods, range, arguments )
    let [l:separator, l:patternExpr, l:replacementExpr, l:flags, l:count] =
    \   ingo#cmdargs#substitute#Parse(a:arguments, {'additionalFlags': 'PwWLER', 'emptyFlags': ['', ''], 'emptyPattern': s:previousPatternExpr, 'emptyReplacement': s:previousReplacementExpr, 'defaultReplacement': s:previousReplacementExpr})
    if empty(l:patternExpr)
	let l:patternExpr = s:previousPatternExpr
    endif

    if l:flags . l:count ==# a:arguments
	if empty(l:flags)
	    let l:flags = s:previousMultipleExprFlags
	endif
	if empty(l:flags)
	    let l:flags = '&'
	endif
	if empty(l:count)
	    let l:count = s:previousMultipleExprCount
	endif
    endif

    try
	let l:patterns = PatternsOnText#EvalIntoList(l:patternExpr)
	let l:replacements = PatternsOnText#EvalIntoList(l:replacementExpr)

	let s:previousPatternExpr = l:patternExpr
	let s:previousReplacementExpr = l:replacementExpr
	let s:previousMultipleExprFlags = l:flags
	let s:previousMultipleExprCount = l:count

	return PatternsOnText#PairsExpr#DoSubstitute(a:mods, a:range, l:patterns, l:replacements, l:flags, l:count)
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    catch /^PatternsOnText:/
	call ingo#err#SetCustomException('PatternsOnText')
	return 0
    endtry
endfunction



function! s:HandleCustomSubstitutionFlags( patterns, replacements, flags, startOfLineAssertion, endOfLineAssertion ) abort
    let l:patterns = a:patterns
    let l:replacements = a:replacements
    let l:flags = a:flags

    let l:appliedPatternFlag = ''
    if l:flags =~# 'P'
	if ! empty(l:appliedPatternFlag)
	    throw printf('Cannot combine flag %s with flag %s', l:appliedPatternFlag, 'P')
	endif
	let l:appliedPatternFlag = 'P'

	let l:flags = ingo#str#trd(l:flags, 'P')
	let l:patterns = map(l:patterns, 'ingo#regexp#EscapeLiteralText(v:val)')
    endif
    if l:flags =~# 'w'
	if ! empty(l:appliedPatternFlag)
	    throw printf('Cannot combine flag %s with flag %s', l:appliedPatternFlag, 'w')
	endif
	let l:appliedPatternFlag = 'w'

	let l:flags = ingo#str#trd(l:flags, 'w')
	let l:patterns = map(l:patterns, 'ingo#regexp#MakeWholeWordSearch(v:val, ingo#regexp#EscapeLiteralText(v:val))')
    endif
    if l:flags =~# 'W'
	if ! empty(l:appliedPatternFlag)
	    throw printf('Cannot combine flag %s with flag %s', l:appliedPatternFlag, 'W')
	endif
	let l:appliedPatternFlag = 'W'

	let l:flags = ingo#str#trd(l:flags, 'W')
	let l:patterns = map(l:patterns, 'ingo#regexp#MakeWholeWORDSearch(v:val, ingo#regexp#EscapeLiteralText(v:val))')
    endif
    if l:flags =~# 'L'
	if ! empty(l:appliedPatternFlag)
	    throw printf('Cannot combine flag %s with flag %s', l:appliedPatternFlag, 'L')
	endif
	let l:appliedPatternFlag = 'L'

	let l:flags = ingo#str#trd(l:flags, 'L')
	let l:patterns = map(l:patterns, 'a:startOfLineAssertion . "\\s*" . ingo#regexp#EscapeLiteralText(v:val) . "\\s*" . a:endOfLineAssertion')
    endif
    if l:flags =~# 'E'
	if ! empty(l:appliedPatternFlag)
	    throw printf('Cannot combine flag %s with flag %s', l:appliedPatternFlag, 'E')
	endif
	let l:appliedPatternFlag = 'E'

	let l:flags = ingo#str#trd(l:flags, 'E')
	let l:patterns = map(l:patterns, 'a:startOfLineAssertion . ingo#regexp#EscapeLiteralText(v:val) . a:endOfLineAssertion')
    endif
    if l:flags =~# 'R'
	let l:flags = ingo#str#trd(l:flags, 'R')
	let l:replacements = map(l:replacements, 'ingo#regexp#EscapeLiteralReplacement(v:val)')
    endif

    return [l:patterns, l:replacements, l:flags]
endfunction
function! PatternsOnText#PairsExpr#DoSubstitute( mods, range, patterns, replacements, flags, count ) abort
    let [l:patterns, l:replacements, l:flags] = s:HandleCustomSubstitutionFlags(a:patterns, a:replacements, a:flags, '^', '$')
    let l:substitutor = PatternsOnText#JoinPatterns(l:patterns, '/')
    if empty(l:substitutor) | return 0 | endif

    try
	let s:replacementExpressions = l:replacements
	execute printf('%s %ssubstitute/%s/\=call(function("s:ReplaceExpression"), l:substitutor.getPatternIndexAndMatch())/%s %s',
	\	    a:mods, a:range, l:substitutor.pattern, l:flags, a:count
	\)
	return 1
    finally
	let s:replacementExpressions = []
    endtry
endfunction
function! PatternsOnText#PairsExpr#SubstituteText( text, patterns, replacements, flags ) abort
    " In substitute(), the /^/ and /%/ assertions only match at the very start / and
    " end of the string, but we want anchoring to line breaks within the string.
    " The start-of-line pattern uses a look-behind assertion for the newline; /\zs/
    " cannot be used because it would prevent successive matches in consecutive
    " lines.
    " The end-of-line pattern includes the trailing newline in the match, so that
    " the full line is replaced.
    let [l:patterns, l:replacements, l:flags] = s:HandleCustomSubstitutionFlags(a:patterns, a:replacements, a:flags, '\%(^\|\n\@<=\)', '\%(\n\|$\)')
    let l:substitutor = PatternsOnText#JoinPatterns(l:patterns, '')
    if empty(l:substitutor) | return a:text | endif

    try
	let s:replacementExpressions = l:replacements
	return substitute(a:text, l:substitutor.pattern, '\=call(function("s:ReplaceExpression"), l:substitutor.getPatternIndexAndMatch())', l:flags)
    finally
	let s:replacementExpressions = []
    endtry
endfunction
function! s:ReplaceExpression( patternIndex, patternMatch )
    return ingo#subst#replacement#ReplaceSpecial(a:patternMatch, get(s:replacementExpressions, a:patternIndex, get(s:replacementExpressions, -1, '')), '&', function('PatternsOnText#ReplaceSpecial'))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
