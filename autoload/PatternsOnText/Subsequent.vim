" PatternsOnText/Subsequent.vim: Commands to substitute matches after the cursor only.
"
" DEPENDENCIES:
"   - ingo/cursor.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/range.vim autoload script
"   - PatternsOnText/Selected.vim autoload script
"
" Copyright: (C) 2014-2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.40.004	27-Oct-2014	FIX: :SubstituteSubsequent can give "E488:
"				Trailing characters". Previous search pattern
"				must be properly escaped in case the separators
"				are different.
"   1.36.003	23-Sep-2014	BUG: :SubstituteSubsequent doesn't work
"				correctly on a closed fold; need to use
"				ingo#range#NetStart().
"   1.30.002	11-Mar-2014	Adapt injection of l:fromCurrentPositionExpr to
"				use \& instead of simple concatentation in order
"				to support patterns anchored with ^.
"				Directly put original pattern into the search
"				history, and remove the full used pattern that
"				contains the restriction from the history.
"				ENH: Add custom 'b' blockwise substitution flag
"				that applies the substitution only in columns on
"				and after the cursor in *all* lines, not just
"				the current one.
"   1.30.001	10-Mar-2014	file creation from plugin/ingocommands.vim.
let s:save_cpo = &cpo
set cpo&vim

let s:previousAnswers = ''
function! PatternsOnText#Subsequent#Substitute( globalCommand, selectedCommand, startLnum, endLnum, arguments )
    call ingo#err#Clear()
    let l:startColumn = virtcol('.')
    let [l:separator, l:pattern, l:replacement, l:substituteFlags, l:answers] = PatternsOnText#Selected#Parse(a:arguments, s:previousAnswers, 'b')
"****D echomsg '****' string( [a:startLnum, a:endLnum, l:separator, l:pattern, l:replacement, l:substituteFlags, l:answers])
    " Handle custom substitution flags.
    let l:isBlockwise = 0
    if l:substituteFlags =~# 'b'
	let l:isBlockwise = 1
	let l:substituteFlags = substitute(l:substituteFlags, '\Cb', '', 'g')
    endif

    let s:previousAnswers = l:answers
    if ingo#range#NetStart(a:startLnum) == ingo#range#NetEnd(a:endLnum) || l:isBlockwise
	let l:fromCurrentPositionExpr = printf('\%%>%dv', l:startColumn - 1)
    else
	let l:fromCurrentPositionExpr = printf('\%%(\%%%dl\%%>%dv\|\%%>%dl\)', line('.'), l:startColumn - 1, line('.'))
    endif

    if empty(l:pattern)
	" An empty pattern usually recalls the last search pattern. Since we
	" prepend a regexp to restrict the location, we need to include it to
	" avoid matching everywhere.
	let l:pattern = PatternsOnText#PreviousSearchPattern(l:separator)
    endif

    try
	execute printf('%d,%d%s%s%s\&\%%(%s\)%s%s%s%s %s',
	\   a:startLnum, a:endLnum,
	\   (empty(l:answers) ? a:globalCommand : a:selectedCommand),
	\   l:separator, l:fromCurrentPositionExpr, l:pattern, l:separator, l:replacement, l:separator, l:substituteFlags, l:answers
	\)

	" The substitution left the cursor on the first non-indent character in
	" the last line with replacements. For this command, position the cursor
	" on the start column instead.
	call ingo#cursor#Set(0, l:startColumn)

	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    finally
	" Don't keep the pattern restriction to matches after the cursor in the
	" search pattern and history; this will only hamper further searches and
	" command redo.
	call histdel('search', -1)
	call histadd('search', escape(ingo#escape#Unescape(l:pattern, l:separator), '/'))
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
