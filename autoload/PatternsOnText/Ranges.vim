" PatternsOnText/Ranges.vim: Commands to work on sub-ranges of the buffer.
"
" DEPENDENCIES:
"   - ingo/cmdargs/range.vim autoload script
"   - ingo/cmdargs/register.vim autoload script
"   - ingo/collections.vim autoload script
"   - ingo/print.vim autoload script
"   - PatternsOnText.vim autoload script
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.40.002	16-Apr-2014	ENH: Allow to pass multiple ranges to the
"				:*Ranges commands.
"				FIX: The *Ranges commands only handled
"				/{pattern}/,... ranges, not line numbers or
"				marks. Only use :global for patterns; for
"				everything else, there's only a single range, so
"				we can just prepend it to :call directly.
"   1.30.001	10-Mar-2014	file creation
let s:save_cpo = &cpo
set cpo&vim

function! s:RecordLine( records, startLnum, endLnum )
    let l:lnum = line('.')
    if l:lnum < a:startLnum || l:lnum > a:endLnum
	return
    endif

    let a:records[l:lnum] = 1
endfunction
function! s:GetLinesInRange( startLnum, endLnum, range )
    let l:recordedLines = {}

    if a:range =~# '^[/?]'
	" For patterns, we need :global to find _all_ (not just the first)
	" matching ranges.
	execute printf('silent! %d,%dglobal %s call <SID>RecordLine(l:recordedLines, %d, %d)',
	\  a:startLnum, a:endLnum,
	\  a:range,
	\  a:startLnum, a:endLnum
	\)
    else
	" For line number, marks, etc., we can just record them (limited to
	" those that fall into the command's range).
	execute printf('silent! %s call <SID>RecordLine(l:recordedLines, %d, %d)',
	\  a:range,
	\  a:startLnum, a:endLnum
	\)
    endif

    return l:recordedLines
endfunction
function! s:Invert( startLnum, endLnum, lnums )
    return filter(
    \   range(a:startLnum, a:endLnum),
    \   '! has_key(a:lnums, v:val)'
    \)
endfunction
function! s:YankLines( lnums, register )
    if a:register ==# '_'
	return
    endif

    let l:lines = map(
    \   sort(copy(a:lnums), 'ingo#collections#numsort'),
    \   'getline(v:val)'
    \)

    call setreg(a:register, join(l:lines, "\n"), 'V')
endfunction
function! s:PrintLines( lnums )
    let l:previousLnum = -1

    for l:lnum in sort(a:lnums, 'ingo#collections#numsort')
	call ingo#print#Number(l:lnum)
	if l:lnum > l:previousLnum + 1
	    " Add every non-contiguous start of a range to the jump list.
	    call cursor(l:lnum, 1)
	    normal! m'
	endif
	let l:previousLnum = l:lnum
    endfor

    " Position the cursor on the last line of the last range.
    call cursor(l:lnum, 1)
endfunction
function! PatternsOnText#Ranges#Command( command, startLnum, endLnum, isNonMatchingLines, arguments )
    if a:command ==# 'print'
	let l:ranges = a:arguments
    else
	let [l:ranges, l:register] = ingo#cmdargs#register#ParseAppendedWritableRegister(a:arguments, '[-+,;''[:alnum:][:space:]\\"|]\@![\x00-\xFF]')
    endif

    let l:lnumsInRanges = {}
    for l:range in split(l:ranges, '\%(' .ingo#cmdargs#range#RangeExpr() . '\)\zs\s\+')
	let l:lnumsInThisRange = s:GetLinesInRange(a:startLnum, a:endLnum, l:range)
"****D echomsg '****' string(l:range) string(l:lnumsInThisRange)
	call extend(l:lnumsInRanges, l:lnumsInThisRange)
    endfor

    let l:lnums = (a:isNonMatchingLines ?
    \   s:Invert(a:startLnum, a:endLnum, l:lnumsInRanges) :
    \   keys(l:lnumsInRanges)
    \)

    if empty(l:lnums)
	return 0
    elseif a:command ==# 'print'
	call s:PrintLines(l:lnums)
    else
	call s:YankLines(l:lnums, (empty(l:register) ? '"' : l:register))
	if a:command ==# 'delete'
	    call PatternsOnText#DeleteLines(l:lnums)
	endif
    endif

    return 1
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
