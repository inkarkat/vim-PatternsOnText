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

function! s:GetFlagsExpr( special, captureGroupCnt ) abort
    return '\(' . ingo#cmdargs#substitute#GetFlags() . '\)\(\%(\s*[' . a:special . ']' . ingo#cmdargs#pattern#PatternExpr(a:captureGroupCnt) . '\)*\)'
endfunction
function! PatternsOnText#Transactional#ParseArguments( previousPattern, previousReplacement, previousFlags, previousSpecialFlags, arguments ) abort
    let l:special = 'tu'
    try
	let [l:separator, l:pattern, l:replacement, l:flags, l:specialFlags] =
	\   ingo#cmdargs#substitute#Parse(a:arguments, {'flagsExpr': s:GetFlagsExpr(l:special, 6), 'flagsMatchCount': 2, 'emptyFlags': ['', ''], 'emptyPattern': a:previousPattern, 'emptyReplacement': a:previousReplacement, 'defaultReplacement': a:previousReplacement})
    catch /^Vim\%((\a\+)\)\=:E65:/ " E65: Illegal back reference
	" Special case of {flags} without /pat/string/. As we use back
	" references for the special flags, and ingo#cmdargs#substitute#Parse()
	" tests the flagsExpr separately in this case, it will fail, and we have
	" to do the parsing and defaulting on our own.
	let l:matches = matchlist(a:arguments, '\C^' . s:GetFlagsExpr(l:special, 3) . '$')
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

    let l:testExpr = ''
    let l:updatePredicate = ''
    let l:rest = l:specialFlags
    while 1
	let l:specialFlagsParse = matchlist(l:rest, '^\s*\([' . l:special . ']\)' . ingo#cmdargs#pattern#PatternExpr(2) . '\(.*\)$')
	if empty(l:specialFlagsParse)
	    break
	endif

	if l:specialFlagsParse[1] ==# l:special[0]
	    let l:testExpr = l:specialFlagsParse[3]
	elseif l:specialFlagsParse[1] ==# l:special[1]
	    let l:updatePredicate = l:specialFlagsParse[3]
	else
	    throw 'ASSERT: Unexpected flag: ' . l:specialFlagsParse[1]
	endif

	let l:rest = l:specialFlagsParse[4]
    endwhile

    return [l:separator, l:pattern, l:replacement, l:flags, l:specialFlags, l:testExpr, l:updatePredicate]
endfunction

function! PatternsOnText#Transactional#Substitute( range, arguments ) abort
endfunction

function! PatternsOnText#Transactional#SubstituteExpr( range, arguments ) abort
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
