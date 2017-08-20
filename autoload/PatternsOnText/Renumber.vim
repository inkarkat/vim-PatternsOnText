" autoload/PatternsOnText/Renumber.vim: Commands to renumber matches.
"
" DEPENDENCIES:
"   - ingo/cmdargs/substitute.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/str.vim autoload script
"
" Copyright: (C) 2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! PatternsOnText#Renumber#Renumber( isPriming, range, arguments )
    if a:arguments !=# '&'
	let [s:startNum, l:subArguments, s:offset] = matchlist(a:arguments, '^\(-\?\d\+\)\?\(.\{-}\)\(-\?\d\+\)\?$')[1:3]
	if empty(s:startNum) | let s:startNum = 1 | endif
	if empty(s:offset) | let s:offset = 1 | endif

	let [l:separator, l:pattern, s:format, l:flags, l:unusedCount] = ingo#cmdargs#substitute#Parse(
	\   ingo#str#Trim(l:subArguments),
	\   {'emptyReplacement': '', 'emptyFlags': ['', '']})

	if empty(l:pattern) | let l:pattern = '[+-]\?\d\+' | endif
	if empty(l:flags) && ! empty(s:format) && s:format =~# '^&\?[cegiInp#lr]*'
	    " The parser has a precedence for replacement over flags, but we can
	    " have either of them. Correct misattributed flags.
	    let [s:format, l:flags] = ['', s:format]
	endif
	if empty(s:format) | let s:format = '%d' | endif

	let s:num = s:startNum
    endif
    if a:isPriming
	return 1
    endif

    try
	execute printf('%ssubstitute%s%s%s\=s:Renumber()%s%s',
	\   a:range, l:separator, l:pattern, l:separator,
	\   l:separator, l:flags
	\)
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction
function! s:Renumber()
    let l:renderedNumber = printf(s:format, s:num)
    let s:num += s:offset
    return l:renderedNumber
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
