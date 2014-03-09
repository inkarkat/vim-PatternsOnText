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
    return keys(l:recordedLines)
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
function! PatternsOnText#Ranges#Delete( startLnum, endLnum, arguments )
    let [l:range, l:register] = ingo#cmdargs#register#ParseAppendedWritableRegister(a:arguments, '[-+[:alnum:][:space:]\\"|]\@![\x00-\xFF]')
    let l:linesInRange = s:GetLinesInRange(a:startLnum, a:endLnum, l:range)
    if empty(l:linesInRange)
	return 0
    else
	call s:YankLines(l:linesInRange, (empty(l:register) ? '"' : l:register))
	call PatternsOnText#DeleteLines(l:linesInRange)
	return 1
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
