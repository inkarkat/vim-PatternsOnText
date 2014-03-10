" PatternsOnText/Subsequent.vim: Commands to substitute matches after the cursor only.
"
" DEPENDENCIES:
"   - ingo/cursor.vim autoload script
"   - ingo/err.vim autoload script
"   - PatternsOnText/Selected.vim autoload script
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.30.001	10-Mar-2014	file creation from plugin/ingocommands.vim.

let s:previousAnswers = ''
function! PatternsOnText#Subsequent#Substitute( globalCommand, selectedCommand, startLnum, endLnum, arguments )
    call ingo#err#Clear()
    let l:startColumn = virtcol('.')
    let [l:separator, l:pattern, l:replacement, l:substituteFlags, l:answers] = PatternsOnText#Selected#Parse(a:arguments, s:previousAnswers)
"****D echomsg '****' string( [a:startLnum, a:endLnum, l:separator, l:pattern, l:replacement, l:substituteFlags, l:answers])
    let s:previousAnswers = l:answers
    if a:startLnum == a:endLnum
	let l:fromCurrentPositionExpr = printf('\%%>%dv', l:startColumn - 1)
    else
	let l:fromCurrentPositionExpr = printf('\%%(\%%%dl\%%>%dv\|\%%>%dl\)', line('.'), l:startColumn - 1, line('.'))
    endif

    if empty(l:pattern)
	" An empty pattern usually recalls the last search pattern. Since we
	" prepend a regexp to restrict the location, we need to include it to
	" avoid matching everywhere.
	let l:pattern = @/
    endif

    try
	execute printf('%d,%d%s%s%s%s%s%s%s%s %s',
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
	call histadd('search', substitute(histget('search', -1), '\V\C' . escape(l:fromCurrentPositionExpr, '\'), '', ''))
    endtry
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
