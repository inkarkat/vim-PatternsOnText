" PatternsOnText/Pairs.vim: Commands to apply multiple pattern-replace pairs.
"
" DEPENDENCIES:
"   - PatternsOnText.vim autoload script
"   - ingo/cmdargs/substitute.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/escape.vim autoload script
"   - ingo/regexp/magic.vim autoload script
"   - ingo/subst/pairs.vim autoload script
"   - ingo/subst/replacement.vim autoload script
"
" Copyright: (C) 2014-2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! s:ParseArguments( arguments )
    let l:count = ''
    let l:flags = ''
    if get(a:arguments, -1, '') =~# '^\d\+$'
	let l:count = remove(a:arguments, -1)
    endif
    if get(a:arguments, -1, '.') =~# '^' . ingo#cmdargs#substitute#GetFlags() . '\d*$'
	let l:flags = remove(a:arguments, -1)
    endif

    return [l:flags, l:count]
endfunction
let [s:previousSplitPairs, s:previousWildcardFlags, s:previousWildcardCount] = [[], '', '']
function! PatternsOnText#Pairs#SubstituteWildcard( range, ... )
    let l:pairs = copy(a:000)
    let [l:flags, l:count] = s:ParseArguments(l:pairs)
    try
	let l:splitPairs = ingo#subst#pairs#Split(l:pairs)
	if empty(l:splitPairs)
	    let l:splitPairs = s:previousSplitPairs
	    if empty(l:flags)
		let l:flags = s:previousWildcardFlags
	    endif
	    if empty(l:flags)
		let l:flags = '&'
	    endif
	    if empty(l:count)
		let l:count = s:previousWildcardCount
	    endif
	endif
	if empty(l:splitPairs)
	    call ingo#err#Set('No pairs')
	    return 0
	endif
	let s:previousSplitPairs = l:splitPairs
	let s:previousWildcardFlags = l:flags
	let s:previousWildcardCount = l:count

	" Surround each individual match with a capturing group, so that we can
	" determine which branch matched (and use the corresponding
	" replacement).
	let l:pattern = join(map(copy(l:splitPairs), '"\\(" . escape(v:val[0], "/") . "\\)"'), '\|')
	let s:replacements = map(copy(l:splitPairs), 'v:val[1]')    " No escaping, returned by sub-replace-expression.

	execute printf('%ssubstitute/%s/\=s:Replace()/%s %s',
	\   a:range, l:pattern, l:flags, l:count
	\)
	return 1
    catch /^Substitute:/
	call ingo#err#SetCustomException('Substitute')
	return 0
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    finally
	let s:replacements = []
    endtry
endfunction



let [s:previousSplitSubstitutions, s:previousMultipleFlags, s:previousMultipleCount] = [[], '', '']
function! s:IsContainsCaptureGroup( pattern ) abort
    return (a:pattern =~# '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\(')
endfunction
function! PatternsOnText#Pairs#SubstituteMultiple( range, arguments )
    let l:argumentsWordSplit = split(a:arguments, '\s\+')
    let [l:flags, l:count] = s:ParseArguments(l:argumentsWordSplit)
    let l:substitutions = (empty(l:flags) && empty(l:count) ?
    \   a:arguments :
    \   matchstr(a:arguments, '^.*\ze\V\C' . (empty(l:flags) ? '' : '\s\+' . l:flags) . (empty(l:count) ? '' : '\s\+' . l:count) . '\$')
    \)
"****D echomsg '****' string(l:substitutions) string(l:flags) string(l:count)
    let l:splitSubstitutions = []
    while ! empty(l:substitutions)
	let [l:separator, l:pattern, l:replacement, l:substitutions] =
	\   ingo#cmdargs#substitute#Parse(l:substitutions, {'flagsExpr': '\s*\(\%([[:alnum:]\\"|]\@![\x00-\xFF]\).*\)\?', 'emptyPattern': @", 'emptyFlags': '', 'isAllowLoneFlags': 0})
	call add(l:splitSubstitutions, [l:separator, l:pattern, l:replacement])
    endwhile
"****D echomsg '****' string(l:splitSubstitutions)
    try
	" Check for forbidden capture groups.
	for l:splitS in l:splitSubstitutions
	    if s:IsContainsCaptureGroup(l:splitS[1])
		call ingo#err#Set('Capture groups not allowed in pattern: ' . ingo#escape#Unescape(l:splitS[1], l:splitS[0]))
		return 0
	    endif
	endfor

	if empty(l:splitSubstitutions)
	    let l:splitSubstitutions = s:previousSplitSubstitutions
	    if empty(l:flags)
		let l:flags = s:previousMultipleFlags
	    endif
	    if empty(l:flags)
		let l:flags = '&'
	    endif
	    if empty(l:count)
		let l:count = s:previousMultipleCount
	    endif
	endif
	if empty(l:splitSubstitutions)
	    call ingo#err#Set('No substitutions')
	    return 0
	endif
	let s:previousSplitSubstitutions = l:splitSubstitutions
	let s:previousMultipleFlags = l:flags
	let s:previousMultipleCount = l:count

	" Unescape as we need to use a common separator and remove any atoms
	" changing the magicness, then surround each individual match with a
	" capturing group, so that we can determine which branch matched (and
	" use the corresponding replacement).
	let l:pattern = join(
	\   map(
	\       copy(l:splitSubstitutions),
	\       '"\\(" . escape(ingo#regexp#magic#Normalize(ingo#escape#Unescape(v:val[1], v:val[0])), "/") . "\\)"'
	\   ),
	\   '\|'
	\)
	let s:replacements = map(
	\   copy(l:splitSubstitutions),
	\   'ingo#escape#Unescape(v:val[2], v:val[0])'
	\)  " No escaping, returned by sub-replace-expression.

	execute printf('%ssubstitute/%s/\=s:Replace()/%s %s',
	\   a:range, l:pattern, l:flags, l:count
	\)
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    finally
	let s:replacements = []
    endtry
endfunction

function! s:Replace()
    for l:i in range(len(s:replacements))
	if ! empty(submatch(l:i + 1))
	    return ingo#subst#replacement#ReplaceSpecial(submatch(l:i + 1), s:replacements[l:i], '&', function('PatternsOnText#Pairs#ReplaceSpecial'))
	endif
    endfor

    " Should never happen; one branch always matches, and branches shouldn't be
    " empty.
    return ''
endfunction
function! PatternsOnText#Pairs#ReplaceSpecial( expr, match, replacement )
    if a:replacement =~# '^\\='
	return eval(a:replacement[2:])
    elseif a:replacement =~# '^' . a:expr . '$'
	return a:match
    endif
    return ingo#escape#UnescapeExpr(a:replacement, '\%(\\\|' . a:expr . '\)')
endfunction



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
function! PatternsOnText#Pairs#SubstituteMultipleExpr( range, arguments )
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
	    if s:IsContainsCaptureGroup(l:patterns[l:i])
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
	    return ingo#subst#replacement#ReplaceSpecial(submatch(l:i + 1), get(s:replacementExpressions, l:i, get(s:replacementExpressions, -1, '')), '&', function('PatternsOnText#Pairs#ReplaceSpecial'))
	endif
    endfor

    " Should never happen; one branch always matches, and branches shouldn't be
    " empty.
    return ''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
