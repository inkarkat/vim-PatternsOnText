" PatternsOnText/Choices.vim: Commands to substitute from a set of choices.
"
" DEPENDENCIES:
"   - PatternsOnText.vim autoload script
"   - PatternsOnText/Selected.vim autoload script
"
" Copyright: (C) 2016 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	27-Sep-2016	file creation

let s:previousChoices = []
function! PatternsOnText#Choices#Substitute( range, arguments )
    let [l:separator, l:pattern, l:replacement, l:flags, l:count] =
    \   ingo#cmdargs#substitute#Parse(a:arguments)

    " The original parsing groups {string1}/{string2} into l:replacement.
    let l:choices = split(l:replacement, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\V' . l:separator)

    let s:lnum = -1
    unlet! s:predefinedChoice
    try
"****D echomsg '****' string([l:separator, l:pattern, l:choices, l:flags, l:count])
	execute printf('%s%s %s%s%s\=PatternsOnText#Choices#QueriedReplace(l:choices)%s%s%s',
	\   a:range, (a:0 ? a:1 : 'substitute'),
	\   l:separator, l:pattern, l:separator, l:separator, l:flags, l:count
	\)
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    catch /^PatternsOnText:/
	call ingo#err#SetCustomException('PatternsOnText')
	return 0
    endtry
endfunction

function! s:ShowContext()
    if line('.') != s:lnum
	" Show the current line; unfortunately, :substitute doesn't update each
	" individual replacement, so a refresh once per line is sufficient.
	if &cursorline
	    redraw!
	else
	    call ingo#print#Number(line('.'))
	endif
    endif
endfunction
function! PatternsOnText#Choices#QueriedReplace( choices )
    if exists('s:predefinedChoice')
	let l:choiceIdx = s:predefinedChoice
    else
	call s:ShowContext()
	let l:choiceIdx = ingo#query#fromlist#Query('replacement', a:choices)
    endif

    if l:choiceIdx < 0
	let s:predefinedChoice = l:choiceIdx    " Emulate abort: All further replacements will be no-ops, without querying the user, too.
	return submatch(0)
    endif

    let l:replacement = a:choices[l:choiceIdx]
    if l:replacement =~# '^\\='
	" Handle sub-replace-special.
	return eval(l:replacement[2:])
    else
	" Handle & and \0, \1 .. \9, and \r\n\t\b (but not \u, \U, etc.)
	return PatternsOnText#ReplaceSpecial('', l:replacement, '\%(&\|\\[0-9rnbt]\)', function('PatternsOnText#Selected#ReplaceSpecial'))
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
