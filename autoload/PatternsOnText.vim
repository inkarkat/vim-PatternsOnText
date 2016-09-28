" PatternsOnText.vim: Common functions for the advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - ingo/collections.vim autoload script
"   - ingo/msg.vim autoload script
"   - ingo/escape.vim autoload script
"
" Copyright: (C) 2013-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
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

function! PatternsOnText#ReplaceSpecial( match, replacement, specialExpr, SpecialReplacer )
    if empty(a:specialExpr)
	return a:replacement
    endif

    return join(
    \   map(
    \       ingo#collections#SplitKeepSeparators(a:replacement, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!' . a:specialExpr),
    \       'call(a:SpecialReplacer, [a:specialExpr, a:match, v:val])'
    \   ),
    \   ''
    \)
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

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
