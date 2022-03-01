" PatternsOnText/UnderCursor.vim: Commands to substitute only the match under the cursor.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2022 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

let s:previousPattern = ''
function! PatternsOnText#UnderCursor#Substitute( arguments ) abort
    call ingo#err#Clear()

    let [l:separator, l:pattern, l:replacement, l:flags, l:count] =
    \   ingo#cmdargs#substitute#Parse(a:arguments, {'emptyPattern': s:previousPattern})
    " We cannot simply let :substitute use the last pattern, as that got
    " embellished with the cursor-limitation.
    if empty(l:pattern)
	" Handle :SubstituteUnderCursor//{replacement}/{flags} by using the last
	" search pattern.
	let l:pattern = escape(ingo#escape#Unescape(@/, '/'), l:separator)
	if empty(l:pattern)
	    call ingo#err#Set('No previous pattern')
	    return 0
	endif
    endif
    let s:previousPattern = escape(ingo#escape#Unescape(l:pattern, l:separator), '/')

    let l:underCursorPattern = ingo#regexp#build#UnderCursor(l:pattern)
    try
	execute printf('substitute%s%s%s%s%s%s',
	\   l:separator, l:underCursorPattern, l:separator, l:replacement, l:separator, l:flags
	\)
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
