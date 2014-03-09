" PatternsOnText/Ranges.vim: Commands to work on sub-ranges of the buffer.
"
" DEPENDENCIES:
"   - PatternsOnText.vim autoload script
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.30.001	10-Mar-2014	file creation
let s:save_cpo = &cpo
set cpo&vim

function! s:RecordLine( records, endLnum )
    let l:lnum = line('.')
    if l:lnum > a:endLnum
	return
    endif

    let a:records[l:lnum] = 1
endfunction
function! s:GetLinesInRange( startLnum, endLnum, range )
    let l:recordedLines = {}
    execute printf('silent! %d,%dglobal %s call <SID>RecordLine(l:recordedLines, %d)',
    \  a:startLnum, a:endLnum,
    \  a:range,
    \  a:endLnum,
    \)
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
function! PatternsOnText#Ranges#Delete( startLnum, endLnum, isNonMatchingLines, arguments )
    let [l:range, l:register] = ingo#cmdargs#register#ParseAppendedWritableRegister(a:arguments, '[-+[:alnum:][:space:]\\"|]\@![\x00-\xFF]')
    let l:lnumsInRange = s:GetLinesInRange(a:startLnum, a:endLnum, l:range)

    let l:lnums = (a:isNonMatchingLines ?
    \   s:Invert(a:startLnum, a:endLnum, l:lnumsInRange) :
    \   keys(l:lnumsInRange)
    \)

    if empty(l:lnums)
	return 0
    else
	call s:YankLines(l:lnums, (empty(l:register) ? '"' : l:register))
	call PatternsOnText#DeleteLines(l:lnums)
	return 1
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
