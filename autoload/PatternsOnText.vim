" PatternsOnText.vim: Common functions for the advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - ingo/collections.vim autoload script
"   - ingo/msg.vim autoload script
"   - ingo/escape.vim autoload script
"
" Copyright: (C) 2013-2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   2.01.008	19-Jul-2017	Fix typo in
"				PatternsOnText#DefaultReplacementOnPredicate()
"				function name.
"				Move
"				PatternsOnText#DefaultReplacementOnPredicate(),
"				PatternsOnText#ReplaceSpecial(), and
"				PatternsOnText#DefaultReplacer() to
"				ingo-library.
"   2.00.007	30-Sep-2016	Refactoring: Factor out
"				PatternsOnText#InitialContext().
"   2.00.006	29-Sep-2016	Move factored out
"				PatternsOnText#DefaultReplacementOnPrediate()
"				here.
"				Move PatternsOnText#Selected#ReplaceSpecial() to
"				PatternsOnText#DefaultReplacer().
"   1.40.005	27-Oct-2014	Add PatternsOnText#PreviousSearchPattern().
"   1.36.004	23-Sep-2014	Make the deletions work with closed folds (i.e.
"				only delete the duplicate lines / lines in range
"				itself, not the entire folds) by temporarily
"				disabling folding.
"   1.30.003	10-Mar-2014	Add PatternsOnText#DeleteLines().
"   1.20.002	17-Jan-2014	Add PatternsOnText#ReplaceSpecial().
"   1.10.001	06-Jun-2013	file creation

function! PatternsOnText#EmulatePreviousReplacement( replacement, previousReplacement )
    " substitute() doesn't support the ~ special character to recall the last
    " substitution text; emulate this from our own history.
    let l:previousReplacementExpr = (&magic ? '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\~' : '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\\~')
    return (a:replacement =~# l:previousReplacementExpr ? substitute(a:replacement, l:previousReplacementExpr, escape(a:previousReplacement, '\'), 'g') : a:replacement)
endfunction

function! PatternsOnText#DeleteLines( lnums )
    if len(a:lnums) == 0
	return
    endif

    " Set a jump on the original position.
    normal! m'

    let l:save_foldenable = &l:foldenable
    setlocal nofoldenable
    try
	" Sort from last to first line to avoid adapting the line numbers.
	for l:lnum in reverse(sort(a:lnums, 'ingo#collections#numsort'))
	    execute 'keepjumps' l:lnum . 'delete _'
	endfor

	" Position the cursor on the line after the last deletion, like
	" :g/.../delete does.
	execute (a:lnums[0] - len(a:lnums) + 1)
	normal! ^
    finally
	let &l:foldenable = l:save_foldenable
    endtry

    " Print a summary.
    if len(a:lnums) > &report
	call ingo#msg#StatusMsg(printf('%d fewer line%s', len(a:lnums), (len(a:lnums) == 1 ? '' : 's')))
    endif
endfunction

function! PatternsOnText#PreviousSearchPattern( separator )
    return escape(ingo#escape#Unescape(@/, '/'), a:separator)
endfunction

function! PatternsOnText#InitialContext()
    return {'matchCount': 0, 'replacementCount': 0, 'lastLnum': line('.'), 'n': 0, 'm': 1, 'l': [], 'd': {}, 's': ''}
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
