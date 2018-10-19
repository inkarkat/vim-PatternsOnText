" PatternsOnText/Uniques.vim: Commands to work on unique matches.
"
" DEPENDENCIES:
"   - ingo/msg.vim autoload script
"
" Copyright: (C) 2014-2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! PatternsOnText#Uniques#FilterUnique( accumulator )
    call filter(a:accumulator, 'v:val.cnt == 1')
endfunction
function! PatternsOnText#Uniques#FilterNonUnique( accumulator )
    call filter(a:accumulator, 'v:val.cnt > 1')
endfunction

function! s:Delete( isInverse, accumulator, startLnum, endLnum, separator, pattern )
    try
	execute printf('silent %d,%dsubstitute %s%s%s\=s:DeleteAccumulated(a:accumulator)%sg',
	\   a:startLnum, a:endLnum, a:separator, a:pattern, a:separator, a:separator
	\)

	call s:ReportDeleteUnique(a:isInverse, a:accumulator)
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#msg#VimExceptionMsg()
    endtry
endfunction
function! PatternsOnText#Uniques#DeleteUnique( accumulator, startLnum, endLnum, separator, pattern )
    return s:Delete(0, a:accumulator, a:startLnum, a:endLnum, a:separator, a:pattern)
endfunction
function! PatternsOnText#Uniques#DeleteNonUnique( accumulator, startLnum, endLnum, separator, pattern )
    return s:Delete(1, a:accumulator, a:startLnum, a:endLnum, a:separator, a:pattern)
endfunction

function! s:DeleteAccumulated( accumulator )
    return (has_key(a:accumulator, submatch(0)) ? '' : submatch(0))
endfunction

function! s:ReportDeleteUnique( isInverse, accumulator )
    let l:lines = {}
    for l:what in keys(a:accumulator)
	let l:lines[keys(a:accumulator[l:what].lnum)[0]] = 1
    endfor

    let l:deletedLines = len(keys(l:lines))
    if l:deletedLines >= &report
	let l:cnt = len(keys(a:accumulator))
	call ingo#msg#StatusMsg(printf('Deleted %d %s match%s in %d line%s',
	\   l:cnt, (a:isInverse ? 'duplicate' : 'unique') , (l:cnt == 1 ? '' : 'es'),
	\   l:deletedLines, (l:deletedLines == 1 ? '' : 's')
	\))
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
