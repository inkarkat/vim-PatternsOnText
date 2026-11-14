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
	let s:replacementExpressions = map(copy(l:exprItems), 'v:val[1]')
	let s:previousExprFlags = l:flags
	let s:previousExprCount = l:count

	" Handle custom substitution flags.
	if l:flags =~# 'P'
	    let l:flags = ingo#str#trd(l:flags, 'P')
	    let l:patterns = map(l:patterns, 'ingo#regexp#EscapeLiteralText(v:val)')
	elseif l:flags =~# 'w'
	    let l:flags = ingo#str#trd(l:flags, 'w')
	    let l:patterns = map(l:patterns, 'ingo#regexp#MakeWholeWordSearch(v:val, ingo#regexp#EscapeLiteralText(v:val))')
	elseif l:flags =~# 'W'
	    let l:flags = ingo#str#trd(l:flags, 'W')
	    let l:patterns = map(l:patterns, 'ingo#regexp#MakeWholeWORDSearch(v:val, ingo#regexp#EscapeLiteralText(v:val))')
	elseif l:flags =~# 'L'
	    let l:flags = ingo#str#trd(l:flags, 'L')
	    let l:patterns = map(l:patterns, '"^\\s*" . ingo#regexp#EscapeLiteralText(v:val) . "\\s*$"')
	elseif l:flags =~# 'E'
	    let l:flags = ingo#str#trd(l:flags, 'E')
	    let l:patterns = map(l:patterns, '"^" . ingo#regexp#EscapeLiteralText(v:val) . "$"')
	elseif l:flags =~# 'R'
	    let l:flags = ingo#str#trd(l:flags, 'R')
	    let s:replacementExpressions = map(s:replacementExpressions, 'ingo#regexp#EscapeLiteralReplacement(v:val)')
	endif

	let l:pattern = PatternsOnText#JoinPatterns(l:patterns)
	if empty(l:pattern) | return 0 | endif

	execute printf('%s %ssubstitute/%s/\=s:ReplaceExpression(%d)/%s %s',
	\   a:mods, a:range, l:pattern, len(l:patterns), l:flags, l:count
	\)
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    finally
	let s:replacementExpressions = []
    endtry
endfunction



let [s:previousPatternExpr, s:previousReplacementExpr, s:previousMultipleExprFlags, s:previousMultipleExprCount] = ['', '', '', '']
function! PatternsOnText#PairsExpr#SubstituteMultipleExpr( mods, range, arguments )
    let [l:separator, l:patternExpr, l:replacementExpr, l:flags, l:count] =
    \   ingo#cmdargs#substitute#Parse(a:arguments, {'emptyFlags': ['', ''], 'emptyPattern': s:previousPatternExpr, 'emptyReplacement': s:previousReplacementExpr, 'defaultReplacement': s:previousReplacementExpr})
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
	let s:replacementExpressions = PatternsOnText#EvalIntoList(l:replacementExpr)

	let l:pattern = PatternsOnText#JoinPatterns(l:patterns)
	if empty(l:pattern) | return 0 | endif

	let s:previousPatternExpr = l:patternExpr
	let s:previousReplacementExpr = l:replacementExpr
	let s:previousMultipleExprFlags = l:flags
	let s:previousMultipleExprCount = l:count

	execute printf('%s %ssubstitute/%s/\=s:ReplaceExpression(%d)/%s %s',
	\   a:mods, a:range, l:pattern, len(l:patterns), l:flags, l:count
	\)
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    finally
	let s:replacementExpressions = []
    endtry
endfunction



function! s:ReplaceExpression( patternNum )
    for l:i in range(a:patternNum)
	if ! empty(submatch(l:i + 1))
	    return ingo#subst#replacement#ReplaceSpecial(submatch(l:i + 1), get(s:replacementExpressions, l:i, get(s:replacementExpressions, -1, '')), '&', function('PatternsOnText#ReplaceSpecial'))
	endif
    endfor

    " Should never happen; one branch always matches, and branches shouldn't be
    " empty.
    return ''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
