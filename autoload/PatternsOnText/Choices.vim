" PatternsOnText/Choices.vim: Commands to substitute from a set of choices.
"
" DEPENDENCIES:
"   - PatternsOnText.vim autoload script
"   - ingo/cmdargs/substitute.vim autoload script
"   - ingo/compat.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/print.vim autoload script
"   - ingo/query.vim autoload script
"   - ingo/query/confirm.vim autoload script
"   - ingo/query/fromlist.vim autoload script
"   - ingo/query/get.vim autoload script
"
" Copyright: (C) 2016 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.60.002	29-Sep-2016	Need to unescape the l:separator in l:choices.
"				Factor out
"				PatternsOnText#DefaultReplacementOnPrediate().
"   1.60.001	27-Sep-2016	file creation

let s:previousPattern = ''
let s:previousChoices = []
function! PatternsOnText#Choices#Substitute( range, arguments, ... )
    let [l:separator, l:pattern, l:replacement, l:flags, l:count] =
    \   ingo#cmdargs#substitute#Parse(a:arguments, {'emptyFlags': ['', ''], 'emptyPattern': s:previousPattern})

    if l:flags . l:count ==# a:arguments
	" Recall previous choices.
	let l:choices = s:previousChoices
	if empty(l:flags)
	    let l:flags = '&'
	endif
    else
	" The original parsing groups {string1}/{string2} into l:replacement.
	let l:choices = split(l:replacement, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\V' . l:separator)
	call map(l:choices, 'ingo#escape#Unescape(v:val, l:separator)')
    endif
    if len(l:choices) <= 1
	call ingo#err#Set(printf('%s replacement given', empty(l:choices) ? 'No' : 'Only one'))
	return 0
    endif
    let s:previousPattern = escape(ingo#escape#Unescape(l:pattern, l:separator), '/')
    let s:previousChoices = l:choices

    " Don't use the built-in :s_c; this would result in two separate queries
    " (and choices like (a)ll would not work right). Instead, emulate this via
    " our own query.
    let l:queryFunction = 'ingo#query#fromlist#Query'
    if l:flags =~# 'c'
	let l:queryFunction = 's:ConfirmQuery'
	let l:flags = substitute(l:flags, '\Cc', '', 'g')
    endif

    let s:lnum = -1
    let s:lastChoice = -1
    unlet! s:predefinedChoice
    try
"****D echomsg '****' string([l:separator, l:pattern, l:choices, l:flags, l:count])
	execute printf('%s%s %s%s%s\=s:Replace(%s, l:choices)%s%s%s',
	\   a:range, (a:0 ? a:1 : 'substitute'),
	\   l:separator, l:pattern, l:separator,
	\   string(l:queryFunction),
	\   l:separator, l:flags, l:count
	\)
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    catch /^PatternsOnText:/
	call ingo#err#SetCustomException('PatternsOnText')
	return 0
    finally
	" Clear the last query.
	echo
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
function! s:Replace( QueryFuncref, choices )
    if exists('s:predefinedChoice')
	let l:choiceIdx = s:predefinedChoice
    else
	redraw " If we let the previous query linger, the actuall buffer contents will slowly scroll out of view.
	let l:choiceIdx = call(a:QueryFuncref, ['replacement', a:choices])
    endif

    if l:choiceIdx < 0 || l:choiceIdx == len(a:choices) " Confirm: quit
	let s:predefinedChoice = l:choiceIdx    " Emulate abort: All further replacements will be no-ops, without querying the user, too.
	return submatch(0)
    elseif l:choiceIdx == len(a:choices) + 1
	" Confirm: all remaining as <last choice>
	let s:predefinedChoice = s:lastChoice
	let l:choiceIdx = s:lastChoice
    else
	let s:lastChoice = l:choiceIdx
    endif

    return PatternsOnText#DefaultReplacementOnPrediate(1, {'replacement': a:choices[l:choiceIdx]})
endfunction

function! s:ConfirmQuery( what, list, ... )
    let l:originalList = a:list + ['&quit']
    if s:lastChoice >= 0
	call add(l:originalList, '&all remaining as ' . a:list[s:lastChoice])
    endif

    let l:defaultIndex = (a:0 ? a:1 : -1)
    let l:confirmList = ingo#query#confirm#AutoAccelerators(copy(l:originalList), -1)
    let l:accelerators = map(copy(l:confirmList), 'matchstr(v:val, "&\\zs.")')
    let l:list = ingo#query#fromlist#RenderList(l:confirmList, l:defaultIndex, '%d:')

    while 1
	let l:renderedQuestion = printf('Select %s via [count] or (l)etter: %s ?', a:what, join(l:list, ', '))
	if ingo#compat#strdisplaywidth(l:renderedQuestion) + 3 > &columns
	    call ingo#query#Question(printf('Select %s via [count] or (l)etter:', a:what))
	    for l:listItem in ingo#query#fromlist#RenderList(l:confirmList, l:defaultIndex, '%3d: ')
		echo l:listItem
	    endfor
	else
	    call ingo#query#Question(l:renderedQuestion)
	endif

	if exists('g:IngoLibrary_QueryChoices') && len(g:IngoLibrary_QueryChoices) > 0
	    " Headless mode: Bypass actual confirm so that no user intervention is
	    " necesary.
	    let l:plainChoices = map(copy(l:originalList), 'ingo#query#StripAccellerator(v:val)')

	    " Return predefined choice.
	    let l:choice = remove(g:IngoLibrary_QueryChoices, 0)
	    return (type(l:choice) == type(0) ?
	\	l:choice :
	\	(l:choice == '' ?
	\	    0 :
	\	    index(l:plainChoices, l:choice)
	\	)
	    \)
	endif

	let l:choice = ingo#query#get#Char()
	if l:choice ==# "\<C-e>" || l:choice ==# "\<C-y>"
	    execute 'normal!' l:choice
	    redraw
	    continue
	endif

	let l:count = (empty(l:choice) ? -1 : index(l:accelerators, l:choice, 0, 1) + 1)
	if l:count == 0
	    let l:count = str2nr(l:choice)
	    if len(l:originalList) > 10 * l:count
		" Need to query more numbers to be able to address all choices.
		echon ' ' . l:count

		while len(l:originalList) > 10 * l:count
		    let l:digit = ingo#query#get#Number(9)
		    if l:digit == -1
			redraw | echo ''
			return -1
		    endif
		    let l:count = 10 * l:count + l:digit
		endwhile
	    endif
	endif

	if l:count < 1 || l:count > len(l:originalList)
	    redraw | echo ''
	    return -1
	endif
	return l:count - 1
    endwhile
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
