" PatternsOnText/Except.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - ingo/err.vim autoload script
"   - ingo/cmdargs.vim autoload script
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.01.005	30-May-2013	Implement abort on error.
"   1.00.004	29-May-2013	Adapt to changed
"				ingo#cmdargs#ParseSubstituteArgument() interface
"				in ingo-library version 1.006.
"   1.00.003	28-May-2013	FIX: Forgot to adapt function names after move.
"				Also re-use the previous (:substitute or
"				:SubstituteExcept) flags by replacing
"				s:SubstituteExcept_PreviousFlags with '&'. Makes
"				more sense this way.
"				CHG: Default to the "g" flag also for
"				:SubstituteExcept, as a single replacement
"				before the first match doesn't make much sense.
"				Handle 'gdefault' setting by inverting the
"				default to "g" then.
"	002	21-Feb-2013	Use ingo-library.
"	001	22-Jan-2013	file creation

function! s:InvertedSubstitute( range, separator, pattern, replacement, flags, count )
    if empty(a:pattern)
	let l:separator = '/'
	let l:pattern = @/
    else
	let l:separator = a:separator
	let l:pattern = a:pattern
    endif

    try
	execute printf('%ssubstitute %s\%%(^\|%s\)\zs\%%(%s\)\@!.\{-1,}\ze\%%(%s\|$\)%s%s%s%s%s',
	\   a:range, l:separator, l:pattern, l:pattern, l:pattern, l:separator, a:replacement, l:separator,
	\   a:flags . (&gdefault || a:flags =~# '^&\|g' ? '' : 'g'), a:count
	\)
	return 1
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction
function! PatternsOnText#Except#Substitute( range, arguments )
    let [l:separator, l:pattern, l:replacement, l:flags, l:count] = ingo#cmdargs#ParseSubstituteArgument(a:arguments)
    return s:InvertedSubstitute(a:range, l:separator, l:pattern, l:replacement, l:flags, l:count)
endfunction
function! PatternsOnText#Except#Delete( range, arguments )
    let [l:separator, l:pattern, l:flags] = ingo#cmdargs#ParsePatternArgument(a:arguments, '\(.*\)')

    let l:success = s:InvertedSubstitute(a:range, l:separator, l:pattern, '', l:flags, '')
    call histdel('search', -1)
    return l:success
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
