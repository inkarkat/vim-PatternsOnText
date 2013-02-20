" PatternsOnText/Duplicates.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - ingo/msg.vim autoload script
"   - ingocmdargs.vim autoload script
"   - ingocollections.vim autoload script
"
" Copyright: (C) 2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	22-Jan-2013	file creation

function! s:FilterDuplicates( accumulator )
    call filter(a:accumulator, 'v:val.cnt > 1')
endfunction
function! PatternsOnText#Duplicates#Process( startLnum, endLnum, arguments, OnDuplicateAction, ReportAction )
    if empty(a:arguments)
	let [l:separator, l:pattern] = ['/', @/]
    else
	let [l:separator, l:pattern] = ingocmdargs#ParsePatternArgument(a:arguments)
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
	    call call(a:ReportAction, [l:accumulator, a:startLnum, a:endLnum])
	endif
    catch /^Vim\%((\a\+)\)\=:E/
	echomsg v:exception
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
	let a:accumulator[l:match].lnum[line('.')] = 1

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
	for l:lnum in sort(keys(l:byFirstOccurrence), 'ingocollections#numsort')
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
		    " We have duplicates over a few lines; list the all.
		    echon ' in '
		    echohl LineNr
		    echon join(sort(keys(a:accumulator[l:what].lnum), 'ingocollections#numsort'), ', ')
		    echohl None
		endif
	    endfor
	endfor
    endif
endfunction
function! PatternsOnText#Duplicates#DeleteMatches( accumulator, match )
    return ''
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
