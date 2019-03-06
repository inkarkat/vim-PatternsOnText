" PatternsOnText/PairsExpr.vim: Commands to apply multiple pattern-replace pairs through expressions.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2014-2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

let [s:previousPatternExpr, s:previousReplacementExpr, s:previousMultipleExprFlags, s:previousMultipleExprCount] = ['', '', '', '']
function! s:EvalIntoList( expr ) abort
    if empty(a:expr)
	return []
    endif

    let l:result = eval(a:expr)
    return (type(l:result) == type([]) ?
    \   l:result :
    \   split(l:result, '\n', 1)
    \)
endfunction
function! PatternsOnText#PairsExpr#SubstituteMultipleExpr( range, arguments )
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
	let l:patterns = s:EvalIntoList(l:patternExpr)
	let s:replacementExpressions = s:EvalIntoList(l:replacementExpr)

	" Check for forbidden capture groups.
	for l:i in range(len(l:patterns))
	    if PatternsOnText#IsContainsCaptureGroup(l:patterns[l:i])
		call ingo#err#Set(printf('Capture groups not allowed in pattern #%d: %s', l:i + 1, l:patterns[l:i]))
		return 0
	    endif
	endfor

	if empty(l:patterns)
	    call ingo#err#Set('No patterns')
	    return 0
	endif

	let s:previousPatternExpr = l:patternExpr
	let s:previousReplacementExpr = l:replacementExpr
	let s:previousMultipleExprFlags = l:flags
	let s:previousMultipleExprCount = l:count

	" Remove any atoms changing the magicness, then surround each individual
	" match with a capturing group, so that we can determine which branch
	" matched (and use the corresponding replacement).
	let l:pattern = join(
	\   map(
	\       copy(l:patterns),
	\       '"\\(" . escape(ingo#regexp#magic#Normalize(v:val), "/") . "\\)"'
	\   ),
	\   '\|'
	\)

	execute printf('%ssubstitute/%s/\=s:ReplaceExpression(%d)/%s %s',
	\   a:range, l:pattern, len(l:patterns), l:flags, l:count
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
