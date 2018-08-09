" PatternsOnText/InSearch.vim: Commands to substitute only within search matches.
"
" DEPENDENCIES:
"   - PatternsOnText.vim autoload script
"   - PatternsOnText/Except.vim autoload script
"   - ingo/cmdargs/substitute.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/msg.vim autoload script
"   - ingo/subst/expr/emulation.vim autoload script
"
" Copyright: (C) 2011-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! PatternsOnText#InSearch#InnerSubstitute( expr, pat, sub, flags )
    let s:didInnerSubstitution = 1
    if a:sub =~# '^\\='
	" Recursive use of \= is not allowed, so we need to emulate it:
	let l:replacement = ingo#subst#expr#emulation#Substitute(a:expr, a:pat, a:sub, a:flags)
    else
	let l:replacement = substitute(a:expr, a:pat, a:sub, a:flags)
    endif
    if a:expr !=# l:replacement
	let s:innerSubstitutionCnt += 1
	let s:innerSubstitutionLnums[line('.')] = 1
    endif
    return l:replacement
endfunction
let s:previousPattern = ''
let s:previousReplacement = ''
function! PatternsOnText#InSearch#Substitute( isOutsideSearch, firstLine, lastLine, arguments ) range
    let [l:separator, l:pattern, l:replacement, l:flags, l:count] =
    \   ingo#cmdargs#substitute#Parse(a:arguments, {'additionalFlags': 'f', 'emptyPattern': s:previousPattern})
    let l:parts = matchlist(l:replacement,
    \   '\C^\(.*\)'.'\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\V' . l:separator . '\m\(.*\)$'
    \)
    if empty(l:parts)
	if a:isOutsideSearch
	    let l:search = PatternsOnText#Except#GetInvertedPattern(l:separator, PatternsOnText#PreviousSearchPattern(l:separator))
	else
	    let l:search = ''
	endif
    else
	" When the search pattern is inlined as
	" :SubstituteInSearch/{search}/{pattern}/{string}/[flags]
	" the original parsing groups {pattern}/{string} into l:replacement.
	if a:isOutsideSearch
	    let l:search = PatternsOnText#Except#GetInvertedPattern(l:separator, l:pattern)
	else
	    let l:search = l:pattern
	endif
	let [l:pattern, l:replacement] = l:parts[1:2]
    endif

    let l:replacement = PatternsOnText#EmulatePreviousReplacement(l:replacement, s:previousReplacement)
    let s:previousPattern = escape(ingo#escape#Unescape(l:pattern, l:separator), '/')
    let s:previousReplacement = l:replacement

    " Handle custom substitution flags.
    let l:substFlags = 'g'
    if l:flags =~# 'f'
	let l:substFlags = ''
	let l:flags = ingo#str#trd(l:flags, 'f')
    endif

    let s:didInnerSubstitution = 0
    let s:innerSubstitutionCnt = 0
    let s:innerSubstitutionLnums = {}
    try
	" Use :silent to suppress the default "M substitutions on N lines"
	" message. We print our own message giving information about the inner
	" substitutions.
	" The separation character must not appear (unescaped) in the expression, so
	" we use the original separator.
	silent execute printf('%d,%dsubstitute %s%s%s\=PatternsOnText#InSearch#InnerSubstitute(submatch(0), %s, %s, %s)%s%s%s',
	\   a:firstLine, a:lastLine,
	\   l:separator, l:search, l:separator,
	\   string(l:pattern),
	\   string(l:replacement),
	\   string(l:substFlags),
	\   l:separator,
	\   l:flags,
	\   l:count
	\)

	if s:didInnerSubstitution && s:innerSubstitutionCnt == 0 && l:flags !~# 'e'
	    call ingo#err#Set('Pattern not found: ' . l:pattern)
	    return 0
	endif

	let l:innerSubstitutionLines = len(keys(s:innerSubstitutionLnums))
	if l:innerSubstitutionLines >= &report
	    call ingo#msg#StatusMsg(printf('%d substitution%s on %d line%s',
	    \   s:innerSubstitutionCnt, (s:innerSubstitutionCnt == 1 ? '' : 's'),
	    \   l:innerSubstitutionLines, (l:innerSubstitutionLines == 1 ? '' : 's')
	    \))
	endif

	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    finally
	unlet! s:didInnerSubstitution s:innerSubstitutionCnt s:innerSubstitutionLnums
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
