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
"
" REVISION	DATE		REMARKS
"   1.36.008	26-Oct-2014	Factor out
"				PatternsOnText#Except#GetInvertedPattern().
"   1.12.007	16-Sep-2013	FIX: Use of \v and \V magicness atoms in the
"				pattern for :DeleteExcept and :SubstituteExcept
"				cause errors like "E54: Unmatched (" and "E486:
"				Pattern not found". Revert to the default
"				'magic' mode after each pattern insertion to the
"				workhorse regular expression.
"				FIX: Abort :DeleteExcept / :SubstituteExcept
"				commands when the pattern contains the set start
"				/ end match patterns \zs / \ze, as these
"				interfere with the internal implemenation. (I
"				managed to replace \ze with \@=, but couldn't
"				substitute \zs with \@<= without affecting the
"				results.)
"   1.10.006	04-Jun-2013	Refactoring: Perform the defaulting to @/
"				outside s:InvertedSubstitute(), partly through
"				ingo#cmdargs#substitute#Parse().
"				Don't remember the convoluted inverted pattern
"				in the history, but rather what was passed to
"				the command.
"   1.02.005	01-Jun-2013	Move functions from ingo/cmdargs.vim to
"				ingo/cmdargs/pattern.vim and
"				ingo/cmdargs/substitute.vim.
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
