" PatternsOnText/InSearch.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - PatternsOnText.vim autoload script
"   - ingo/cmdargs/substitute.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/msg.vim autoload script
"
" Copyright: (C) 2011-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.30.006	07-Mar-2014	Emulate use of \= sub-replace-expression.
"   1.12.005	14-Jun-2013	Minor: Make substitute() robust against
"				'ignorecase'.
"   1.10.004	06-Jun-2013	Factor out
"				PatternsOnText#EmulatePreviousReplacement(); it
"				is also needed by PatternsOnText/Selected.vim.
"   1.02.005	01-Jun-2013	Move functions from ingo/cmdargs.vim to
"				ingo/cmdargs/pattern.vim and
"				ingo/cmdargs/substitute.vim.
"   1.01.005	30-May-2013	Implement abort on error.
"   1.00.004	29-May-2013	Adapt to changed
"				ingo#cmdargs#ParseSubstituteArgument() interface
"				in ingo-library version 1.006.
"   1.00.003	28-May-2013	Use ingo#msg#StatusMsg().
"				Replace the custom parsing with the (extended
"				new) parsing of
"				ingo#cmdargs#ParseSubstituteArgument().
"   1.00.002	06-Mar-2013	Print :substitute-like summary for the inner
"				substitutions instead of the rather meaningless
"				default summary from the outer :substitute
"				command.
"	001	22-Jan-2013	file creation
let s:save_cpo = &cpo
set cpo&vim

function! s:Submatch( idx )
    return get(s:submatches, a:idx, '')
endfunction
function! s:EmulateSubmatch( expr, pat, sub )
    let s:submatches = matchlist(a:expr, a:pat)
	let l:innerReplacement = eval(a:sub)
    unlet s:submatches
    return l:innerReplacement
endfunction
function! PatternsOnText#InSearch#InnerSubstitute( expr, pat, sub, flags )
    let s:didInnerSubstitution = 1
    if a:sub =~# '^\\='
	" Recursive use of \= is not allowed, so we need to emulate it:
	" matchlist() will get us the list of (sub-)matches, which we'll inject
	" into the passed expression via a s:Submatch() surrogate function for
	" submatch().
	let l:emulatedSub = substitute(a:sub[2:], '\w\@<!submatch\s*(', 's:Submatch(', 'g')

	if a:flags ==# 'g'
	    " For a global replacement, we need to separate the pattern matches
	    " from the surrounding text, and process each match in turn.
	    let l:innerParts = ingo#collections#SplitKeepSeparators(a:expr, a:pat, 1)
	    let l:replacement = ''
	    while ! empty(l:innerParts)
		let l:innerSurroundingText = remove(l:innerParts, 0)
		if empty(l:innerParts)
		    let l:replacement .= l:innerSurroundingText
		else
		    let l:innerExpr = remove(l:innerParts, 0)
		    let l:replacement .= l:innerSurroundingText . s:EmulateSubmatch(l:innerExpr, a:pat, l:emulatedSub)
		endif
	    endwhile
	else
	    " For a first-only replacement, just match and replace once.
	    let s:submatches = matchlist(a:expr, a:pat)
	    let l:innerReplacement = s:EmulateSubmatch(a:expr, a:pat, l:emulatedSub)
	    let l:replacement = substitute(a:expr, a:pat, escape(l:innerReplacement, '\&'), '')
	endif
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
function! PatternsOnText#InSearch#Substitute( firstLine, lastLine, arguments ) range
    let [l:separator, l:pattern, l:replacement, l:flags, l:count] =
    \   ingo#cmdargs#substitute#Parse(a:arguments, {'additionalFlags': 'f', 'emptyPattern': s:previousPattern})

    let l:replacement = PatternsOnText#EmulatePreviousReplacement(l:replacement, s:previousReplacement)
    let s:previousPattern = l:pattern
    let s:previousReplacement = l:replacement

    " Handle custom substitution flags.
    let l:substFlags = 'g'
    if l:flags =~# 'f'
	let l:substFlags = ''
	let l:flags = substitute(l:flags, '\Cf', '', 'g')
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
	silent execute printf('%d,%dsubstitute %s%s\=PatternsOnText#InSearch#InnerSubstitute(submatch(0), %s, %s, %s)%s%s%s',
	\   a:firstLine, a:lastLine,
	\   l:separator, l:separator,
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
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#err#SetVimException()
	return 0
    finally
	unlet! s:didInnerSubstitution s:innerSubstitutionCnt s:innerSubstitutionLnums
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
