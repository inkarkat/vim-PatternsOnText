" PatternsOnText/Pairs.vim: Commands to apply multiple pattern-replace pairs.
"
" DEPENDENCIES:
"   - PatternsOnText.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/escape.vim autoload script
"   - ingo/subst/pairs.vim autoload script
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.21.010	05-Mar-2014	FIX: Need to escape '\\' in addition to the
"				passed a:expr (after the previous fix).
"   1.21.009	20-Feb-2014	FIX: Wrong use of ingo#escape#Unescape(); need
"				to unescape the \& or \\1 (to & or \1) via
"				substitute(), as the library function does not
"				take an expression.
"   1.20.002	17-Jan-2014	Implement replacement with special "&" symbol.
"   1.20.001	16-Jan-2014	file creation
let s:save_cpo = &cpo
set cpo&vim

function! s:ParseArguments( arguments )
    let l:count = ''
    let l:flags = ''
    if a:arguments[-1] =~# '^\d\+$'
	let l:count = remove(a:arguments, -1)
    endif
    if a:arguments[-1] =~# '^&\?[cegiInp#lr]*\d*$'
	let l:flags = remove(a:arguments, -1)
    endif

    return [l:flags, l:count]
endfunction
function! PatternsOnText#Pairs#SubstituteWildcard( range, ... )
    let l:pairs = copy(a:000)
    let [l:flags, l:count] = s:ParseArguments(l:pairs)
    try
	let l:splitPairs = ingo#subst#pairs#Split(l:pairs)
	" Surround each individual match with a capturing group, so that we can
	" determine which branch matched (and use the corresponding
	" replacement).
	let l:pattern = join(map(copy(l:splitPairs), '"\\(" . escape(v:val[0], "/") . "\\)"'), '\|')
	let s:replacements = map(copy(l:splitPairs), 'v:val[1]')    " No escaping, returned by sub-replace-expression.

	execute printf('%ssubstitute/%s/\=s:Replacement()/%s %s',
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
function! PatternsOnText#Pairs#SubstituteMultiple( range, ... )
    let l:substitutions = copy(a:000)
    let [l:flags, l:count] = s:ParseArguments(l:substitutions)
    try
	let l:splitSubstitutions = map(
	\   l:substitutions,
	\   'ingo#cmdargs#substitute#Parse(v:val, {"flagsExpr": "", "emptyPattern": @", "emptyFlags": "", "isAllowLoneFlags": 0})[0:2]'
	\)

	" Check for forbidden capture groups.
	for l:splitS in l:splitSubstitutions
	    if l:splitS[1] =~# '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\('
		call ingo#err#Set('Capture groups not allowed in pattern: ' . ingo#escape#Unescape(l:splitS[1], l:splitS[0]))
		return 0
	    endif
	endfor

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

	execute printf('%ssubstitute/%s/\=s:Replacement()/%s %s',
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

function! s:Replacement()
    for l:i in range(len(s:replacements))
	if ! empty(submatch(l:i + 1))
	    return PatternsOnText#ReplaceSpecial(submatch(l:i + 1), s:replacements[l:i], '&', function('PatternsOnText#Pairs#ReplaceSpecial'))
	endif
    endfor

    " Should never happen; one branch always matches, and branches shouldn't be
    " empty.
    return ''
endfunction
function! PatternsOnText#Pairs#ReplaceSpecial( expr, match, replacement )
    if a:replacement =~# '^' . a:expr . '$'
	return a:match
    endif
    return ingo#escape#UnescapeExpr(a:replacement, '\%(\\\|' . a:expr . '\)')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
