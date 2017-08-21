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
let s:save_cpo = &cpo
set cpo&vim

let s:numberExpr = '[+-]\?\d\+\%(\.\d\+\%([eE][+-]\?\d\+\)\?\)\?'
function! s:IsFloat( num )
    return (a:num =~# '\.')
endfunction
function! PatternsOnText#Renumber#Renumber( isPriming, range, arguments )
    if a:arguments !=# '&'
	let [l:startNum, l:subArguments, l:multiplicator, l:offset] =
	\   matchlist(a:arguments, '^\(' . s:numberExpr . '\)\?\(.\{-}\)\%(\(\*\)\?\(' . s:numberExpr . '\)\)\?$')[1:4]
	let l:isFloat = (s:IsFloat(l:startNum) || s:IsFloat(l:offset))
	execute 'let s:startNum =' (empty(l:startNum) ? 1 : l:startNum)
	execute 'let s:offset =' (empty(l:offset) ? 1 : l:offset)
	let s:operator = (empty(l:multiplicator) ? '+' : '*')

	let [s:separator, s:pattern, s:format, s:flags, l:unusedCount] = ingo#cmdargs#substitute#Parse(
	\   ingo#str#Trim(l:subArguments),
	\   {'emptyReplacement': '', 'emptyFlags': ['', '']})
	if (empty(s:separator) || s:separator ==# '.') && ! empty(s:pattern)
	    call ingo#err#Set('Missing separators around /{pattern}/')
	    return 0
	endif

	if empty(s:pattern) | let s:pattern = s:numberExpr | endif
	if empty(s:flags) && ! empty(s:format) && s:format =~# '^&\?[cegiInp#lr]*$'
	    " The parser has a precedence for replacement over flags, but we can
	    " have either of them. Correct misattributed flags.
	    let [s:format, s:flags] = ['', s:format]
	endif
	if empty(s:format)
	    let s:format = (l:isFloat ? '%g' : '%d')
	endif

	let s:num = s:startNum
    endif
    if a:isPriming
	return 1
    endif

    call ingo#err#Clear()
    try
	execute printf('%ssubstitute%s%s%s\=s:Renumber()%s%s',
	\   a:range, s:separator, s:pattern, s:separator,
	\   s:separator, s:flags
	\)

	return ! ingo#err#IsSet()
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction
function! s:Renumber()
    try
	let l:renderedNumber = printf(s:format, s:num)
	execute 'let s:num = s:num ' s:operator 's:offset'
	return l:renderedNumber
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return submatch(0)
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
