" PatternsOnText.vim: Common functions for the advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2013-2022 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! PatternsOnText#EmulatePreviousReplacement( replacement, previousReplacement )
    " substitute() doesn't support the ~ special character to recall the last
    " substitution text; emulate this from our own history.
    let l:previousReplacementExpr = (&magic ? '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\~' : '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\\~')
    return (a:replacement =~# l:previousReplacementExpr ? substitute(a:replacement, l:previousReplacementExpr, escape(a:previousReplacement, '\'), 'g') : a:replacement)
endfunction

function! PatternsOnText#DeleteLines( lnums )
    if len(a:lnums) == 0
	return
    endif

    " Set a jump on the original position.
    normal! m'

    let l:save_foldenable = &l:foldenable
    setlocal nofoldenable
    try
	" Sort from last to first line to avoid adapting the line numbers.
	for l:lnum in reverse(sort(a:lnums, 'ingo#collections#numsort'))
	    execute 'keepjumps' l:lnum . 'delete _'
	endfor

	" Position the cursor on the line after the last deletion, like
	" :g/.../delete does.
	execute (a:lnums[0] - len(a:lnums) + 1)
	normal! ^
    finally
	let &l:foldenable = l:save_foldenable
    endtry

    " Print a summary.
    if len(a:lnums) > &report
	call ingo#msg#StatusMsg(printf('%d fewer line%s', len(a:lnums), (len(a:lnums) == 1 ? '' : 's')))
    endif
endfunction

function! PatternsOnText#PreviousSearchPattern( separator )
    return escape(ingo#escape#Unescape(@/, '/'), a:separator)
endfunction

function! PatternsOnText#InitialContext()
    return {'matchCount': 0, 'replacementCount': 0, 'lastLnum': line('.'), 'n': 0, 'm': 1, 'l': [], 'd': {}, 's': ''}
endfunction

function! PatternsOnText#ReplaceSpecial( expr, match, replacement )
    if a:replacement =~# '^\\='
	return eval(a:replacement[2:])
    elseif a:replacement =~# '^' . a:expr . '$'
	return a:match
    endif
    return ingo#escape#UnescapeExpr(a:replacement, '\%(\\\|' . a:expr . '\)')
endfunction

function! PatternsOnText#IsContainsCaptureGroup( pattern ) abort
    return (a:pattern =~# '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\(')
endfunction

function! PatternsOnText#EvalIntoList( expr ) abort
    if empty(a:expr)
	return []
    endif

    let l:result = eval(a:expr)
    return (type(l:result) == type([]) ?
    \   l:result :
    \   split(l:result, '\n', 1)
    \)
endfunction

function! PatternsOnText#JoinPatterns( patterns ) abort
    if empty(a:patterns)
	call ingo#err#Set('No patterns')
	return ''
    endif

    " Check for forbidden capture groups.
    for l:i in range(len(a:patterns))
	if PatternsOnText#IsContainsCaptureGroup(a:patterns[l:i])
	    call ingo#err#Set(printf('Capture groups not allowed in pattern #%d: %s', l:i + 1, a:patterns[l:i]))
	    return ''
	endif
    endfor

    " Remove any atoms changing the magicness, then surround each individual
    " match with a capturing group, so that we can determine which branch
    " matched (and use the corresponding replacement).
    return join(
    \  map(
    \      copy(a:patterns),
    \      '"\\(" . escape(ingo#regexp#magic#Normalize(v:val), "/") . "\\)"'
    \  ),
    \  '\|'
    \)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
