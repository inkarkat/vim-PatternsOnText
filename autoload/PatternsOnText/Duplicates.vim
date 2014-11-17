" PatternsOnText/Duplicates.vim: Commands to work on duplicates.
"
" DEPENDENCIES:
"   - ingo/msg.vim autoload script
"   - ingo/cmdargs/pattern.vim autoload script
"   - ingo/collections.vim autoload script
"   - ingo/range.vim autoload script
"
" Copyright: (C) 2013-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.36.006	23-Sep-2014	Correctly report :PrintDuplicates on folded
"				lines.
"   1.02.005	01-Jun-2013	Move functions from ingo/cmdargs.vim to
"				ingo/cmdargs/pattern.vim and
"				ingo/cmdargs/substitute.vim.
"   1.00.004	28-May-2013	Remove a suspect duplicate :echomsg.
"				Use ingo#msg#StatusMsg().
"   1.00.003	04-Mar-2013	ENH: Also print :substitute-like summary on
"				deletion via
"				PatternsOnText#Duplicates#ReportDeletedMatches().
"	002     21-Feb-2013     Move to ingo-library.
"	001	22-Jan-2013	file creation
let s:save_cpo = &cpo
set cpo&vim

function! s:FilterDuplicates( accumulator )
    call filter(a:accumulator, 'v:val.cnt > 1')
endfunction
function! PatternsOnText#Duplicates#Process( startLnum, endLnum, arguments, OnDuplicateAction, ReportAction )
    if empty(a:arguments)
	let [l:separator, l:pattern] = ['/', @/]
    else
	let [l:separator, l:pattern] = ingo#cmdargs#pattern#Parse(a:arguments)
    endif

    let l:accumulator = {}
    try
	execute printf('silent %d,%dsubstitute %s%s%s\=s:Collect(l:accumulator%s)%sg',
	\   a:startLnum, a:endLnum, l:separator, l:pattern, l:separator,
	\   (empty(a:OnDuplicateAction) ? '' : ', ' . string(a:OnDuplicateAction)),
	\   l:separator
	\)

	call s:FilterDuplicates(l:accumulator)
"****D echomsg '****' string(l:accumulator)
	if empty(l:accumulator)
	    return 0
	elseif ! empty(a:ReportAction)
	    call call(a:ReportAction, [l:accumulator, ingo#range#NetStart(a:startLnum), ingo#range#NetEnd(a:endLnum)])
	endif
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#msg#VimExceptionMsg()
    endtry

    return 1
endfunction
function! s:Collect( accumulator, ... )
    let l:match = submatch(0)

    if empty(l:match)
	continue
    endif

    if ! has_key(a:accumulator, l:match)
	let a:accumulator[l:match] = {'cnt': 1, 'lnum': {line('.') : 1}, 'first': line('.')}
    else
	let a:accumulator[l:match].cnt += 1
	let a:accumulator[l:match].lnum[line('.')] = get(a:accumulator[l:match].lnum, line('.'), 0) + 1

	if a:0
	    let l:match = call(a:1, [a:accumulator, l:match])
	endif
    endif

    return l:match
endfunction
function! PatternsOnText#Duplicates#PrintMatches( accumulator, startLnum, endLnum )
    if a:startLnum == a:endLnum
	for l:what in sort(keys(a:accumulator))
	    echohl LineNr
	    echo a:startLnum
	    echohl None

	    echon ' '
	    echohl Directory
	    echon l:what
	    echohl None
	    echon ': ' . a:accumulator[l:what].cnt
	endfor
    else
	" List duplicates sorted by first occurrence.
	let l:byFirstOccurrence = {}
	for l:what in keys(a:accumulator)
	    let l:first = a:accumulator[l:what].first
	    if ! has_key(l:byFirstOccurrence, l:first)
		let l:byFirstOccurrence[l:first] = [l:what]
	    else
		call add(l:byFirstOccurrence[l:first], l:what)
	    endif
	endfor
"****D echomsg '****' string(l:byFirstOccurrence)
	for l:lnum in sort(keys(l:byFirstOccurrence), 'ingo#collections#numsort')
	    for l:what in sort(l:byFirstOccurrence[l:lnum])
		echohl LineNr
		echo l:lnum
		echohl None

		echon ' '
		echohl Directory
		echon l:what
		echohl None
		echon ': ' . a:accumulator[l:what].cnt

		if len(a:accumulator[l:what].lnum) > 7
		    " We have duplicates distributed over many lines, add a
		    " summary.
		    echon printf(' in %d lines', len(a:accumulator[l:what].lnum))
		elseif len(a:accumulator[l:what].lnum) > 1
		    " We have duplicates over a few lines; list them all.
		    echon ' in '
		    echohl LineNr
		    echon join(sort(keys(a:accumulator[l:what].lnum), 'ingo#collections#numsort'), ', ')
		    echohl None
		endif
	    endfor
	endfor
    endif
endfunction
function! PatternsOnText#Duplicates#DeleteMatches( accumulator, match )
    return ''
endfunction
function! PatternsOnText#Duplicates#ReportDeletedMatches( accumulator, startLnum, endLnum )
    let l:lines = {}
    let l:cnt = 0
    for l:what in keys(a:accumulator)
	let l:cnt += a:accumulator[l:what].cnt - 1
	for l:lnum in keys(a:accumulator[l:what].lnum)
	    if a:accumulator[l:what].first == l:lnum && a:accumulator[l:what].lnum[l:lnum] == 1
		" Don't count a line when it contains the first instance and no
		" more instances.
		continue
	    endif
	    let l:lines[l:lnum] = 1
	endfor
    endfor

    let l:deletedLines = len(keys(l:lines))
    if l:deletedLines >= &report
	if len(keys(a:accumulator)) > 1
	    call ingo#msg#StatusMsg(printf('Deleted %d instance%s of %d duplicates in %d line%s',
	    \   l:cnt, (l:cnt == 1 ? '' : 's'),
	    \   len(keys(a:accumulator)),
	    \   l:deletedLines, (l:deletedLines == 1 ? '' : 's')
	    \))
	else
	    call ingo#msg#StatusMsg(printf('Deleted %d duplicate instance%s in %d line%s',
	    \   l:cnt, (l:cnt == 1 ? '' : 's'),
	    \   l:deletedLines, (l:deletedLines == 1 ? '' : 's')
	    \))
	endif
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
