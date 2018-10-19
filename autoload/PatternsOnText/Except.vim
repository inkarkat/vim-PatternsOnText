" PatternsOnText/Except.vim: Commands to substitute where the pattern does not match.
"
" DEPENDENCIES:
"   - ingo/err.vim autoload script
"   - ingo/cmdargs/pattern.vim autoload script
"   - ingo/cmdargs/substitute.vim autoload script
"   - ingo/cmdargs.vim autoload script
"
" Copyright: (C) 2011-2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! PatternsOnText#Except#GetInvertedPattern( separator, pattern )
    if empty(a:pattern) | throw 'ASSERT: Passed pattern must not be empty' | endif
    if a:pattern =~# '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\z[se]'
	throw printf('PatternsOnText: The pattern cannot use the set start / end match patterns \zs / \ze: %s%s%s', a:separator, a:pattern, a:separator)
    endif

    return printf('\%%(^\|%s\m\)\zs\%%(%s\m\)\@!.\{-1,}\ze\%%(%s\m\|$\)',
    \   a:pattern, a:pattern, a:pattern
    \)
endfunction
function! s:InvertedSubstitute( range, separator, pattern, replacement, flags, count )
    call ingo#err#Clear()
    try
	execute printf('%ssubstitute %s%s%s%s%s%s%s',
	\   a:range, a:separator,
	\   PatternsOnText#Except#GetInvertedPattern(a:separator, a:pattern),
	\   a:separator, a:replacement, a:separator,
	\   a:flags . (&gdefault || a:flags =~# '^&\|g' ? '' : 'g'), a:count
	\)

	return 1
    catch /^PatternsOnText:/
	call ingo#err#SetCustomException('PatternsOnText')
	return 0
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    finally
	" Don't remember the convoluted inverted pattern, but rather what was passed
	" to the :SubstituteExcept command.
	call histdel('search', -1)
	call histadd('search', escape(ingo#escape#Unescape(a:pattern, a:separator), '/'))
    endtry
endfunction
function! PatternsOnText#Except#Substitute( range, arguments )
    let [l:separator, l:pattern, l:replacement, l:flags, l:count] = ingo#cmdargs#substitute#Parse(a:arguments, {'emptyPattern': @/})
"****D echomsg '****' string([l:separator, l:pattern, l:replacement, l:flags, l:count])
    return s:InvertedSubstitute(a:range, l:separator, l:pattern, l:replacement, l:flags, l:count)
endfunction
function! PatternsOnText#Except#Delete( range, arguments )
    let [l:separator, l:pattern, l:flags] = ingo#cmdargs#pattern#Parse(a:arguments, '\(.*\)')

    return s:InvertedSubstitute(a:range, (empty(l:pattern) ? '/' : l:separator), (empty(l:pattern) ? @/ : l:pattern), '', l:flags, '')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
