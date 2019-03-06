" PatternsOnText/Transactional.vim: Commands to apply substitutions either all or not at all.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2019 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

let s:special = 'tu'
function! s:GetFlagsExpr( captureGroupCnt ) abort
    return '\(' . ingo#cmdargs#substitute#GetFlags() . '\)\(\%(\s*[' . s:special . ']' . ingo#cmdargs#pattern#PatternExpr(a:captureGroupCnt) . '\)*\)'
endfunction
function! PatternsOnText#Transactional#ParseArguments( previousPattern, previousReplacement, previousFlags, previousSpecialFlags, arguments ) abort
    try
	let [l:separator, l:pattern, l:replacement, l:flags, l:specialFlags] =
	\   ingo#cmdargs#substitute#Parse(a:arguments, {'flagsExpr': s:GetFlagsExpr(6), 'flagsMatchCount': 2, 'emptyFlags': ['', ''], 'emptyPattern': a:previousPattern, 'emptyReplacement': a:previousReplacement, 'defaultReplacement': a:previousReplacement})
    catch /^Vim\%((\a\+)\)\=:E65:/ " E65: Illegal back reference
	" Special case of {flags} without /pat/string/. As we use back
	" references for the special flags, and ingo#cmdargs#substitute#Parse()
	" tests the flagsExpr separately in this case, it will fail, and we have
	" to do the parsing and defaulting on our own.
	let l:matches = matchlist(a:arguments, '\C^' . s:GetFlagsExpr(3) . '$')
	let [l:separator, l:pattern, l:replacement, l:flags, l:specialFlags] =
	\   ['/', a:previousPattern, a:previousReplacement, get(l:matches, 1, ''), get(l:matches, 2, '')]
    endtry
    if empty(l:pattern)
	let l:pattern = a:previousPattern
    endif

    if l:flags . l:specialFlags ==# a:arguments
	if empty(l:flags)
	    let l:flags = a:previousFlags
	endif
	if empty(l:flags)
	    let l:flags = '&'
	endif
	if empty(l:specialFlags)
	    let l:specialFlags = a:previousSpecialFlags
	endif
    endif

    return [l:separator, l:pattern, l:replacement, l:flags, l:specialFlags] + s:ParseSpecialFlags(l:specialFlags)
endfunction
function! s:ParseSpecialFlags( specialFlags ) abort
    let l:result = ['', '']
    let l:rest = a:specialFlags
    while 1
	let l:specialFlagsParse = matchlist(l:rest, '^\s*\([' . s:special . ']\)' . ingo#cmdargs#pattern#PatternExpr(2) . '\(.*\)$')
	if empty(l:specialFlagsParse)
	    break
	endif

	let l:specialIdx = stridx(s:special, l:specialFlagsParse[1])
	if l:specialIdx == -1 | throw 'ASSERT: Unexpected flag: ' . l:specialFlagsParse[1] | endif
	let l:result[l:specialIdx] = l:specialFlagsParse[3]
	let l:rest = l:specialFlagsParse[4]
    endwhile

    return l:result
endfunction

function! PatternsOnText#Transactional#Substitute( range, arguments ) abort
endfunction

function! PatternsOnText#Transactional#SubstituteExpr( range, arguments ) abort
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
