" PatternsOnText/Except.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - ingo/msg.vim autoload script
"   - ingo/cmdargs.vim autoload script
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	003	28-May-2013	FIX: Forgot to adapt function names after move.
"	002	21-Feb-2013	Use ingo-library.
"	001	22-Jan-2013	file creation

function! s:InvertedSubstitute( range, separator, pattern, replacement, flags )
    if empty(a:pattern)
	let l:separator = '/'
	let l:pattern = @/
    else
	let l:separator = a:separator
	let l:pattern = a:pattern
    endif

    try
	execute printf('%ssubstitute %s\%%(^\|%s\)\zs\%%(%s\)\@!.\{-1,}\ze\%%(%s\|$\)%s%s%s%s',
	\   a:range, l:separator, l:pattern, l:pattern, l:pattern, l:separator, a:replacement, l:separator, a:flags
	\)
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#msg#VimExceptionMsg()
    endtry
endfunction
let s:SubstituteExcept_PreviousFlags = ''
function! PatternsOnText#Except#Substitute( range, arguments )
    let [l:separator, l:pattern, l:replacement, l:flags] = ingo#cmdargs#ParseSubstituteArgument(a:arguments, '~', s:SubstituteExcept_PreviousFlags, '\(\S*\)')
    let s:SubstituteExcept_PreviousFlags = l:flags
"****D echomsg '****' string([l:separator, l:pattern, l:replacement, l:flags])
    call s:InvertedSubstitute(a:range, l:separator, l:pattern, l:replacement, l:flags)
endfunction
function! PatternsOnText#Except#Delete( range, arguments )
    let [l:separator, l:pattern, l:flags] = ingo#cmdargs#ParsePatternArgument(a:arguments, '\(.*\)')

    call s:InvertedSubstitute(a:range, l:separator, l:pattern, '', 'g' . l:flags)
    call histdel('search', -1)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
