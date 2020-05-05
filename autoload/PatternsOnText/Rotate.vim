" PatternsOnText/Rotate.vim: Commands to rotate the matches as preceding / following replacements.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

let [s:previousPattern, s:previousShiftValue, s:previousOffset, s:previousFlags, s:previousSpecialFlags] = ['', '', 0, '', '']
function! PatternsOnText#Rotate#Substitute( range, arguments ) abort
    let [l:separator, l:pattern, l:replacement, s:previousFlags, s:previousSpecialFlags, l:testExpr, l:updatePredicate] = PatternsOnText#Transactional#Common#ParseArguments(s:previousPattern, '', s:previousFlags, s:previousSpecialFlags, a:arguments)
    let l:unescapedPattern = ingo#escape#Unescape(l:pattern, l:separator)
    let s:previousPattern = escape(l:unescapedPattern, '/')
    if ! empty(l:replacement)
	let l:parse = matchlist(l:replacement, '^\(\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!' . escape(l:separator, '\') . '\)\?\([+-]\?\d\+\)$')
	if empty(l:parse)
	    call ingo#err#Set('Missing [/{shift-value}]/[+-]N/')
	    return 0
	endif
	if ! empty(l:parse[1])
	    let s:previousShiftValue = l:parse[2]
	endif
	let s:previousOffset = str2nr(l:parse[3])
    endif
    if empty(s:previousOffset)
	call ingo#err#Set('Missing [/{shift-value}]/[+-]N/')
	return 0
    endif

    let l:rotatingReplacementExpression = printf('\=v:val.matches[(((v:val.matchCount + %d - 1) %% v:val.matchNum) + v:val.matchNum) %% v:val.matchNum + 1]', s:previousOffset)

    return PatternsOnText#Transactional#TransactionalSubstitute(a:range, l:unescapedPattern, l:rotatingReplacementExpression, s:previousFlags, l:testExpr, l:updatePredicate)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
