" PatternsOnText/Selected.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - ingo/err.vim autoload script
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.10.003	03-Jun-2013	Factor out
"				PatternsOnText#Selected#CreateAnswers() and
"				PatternsOnText#Selected#GetAnswer().
"				ENH: Handle count before "y" and "n" answers,
"				numeric positions "2,5", and ranges "3-5".
"   1.01.002	30-May-2013	Implement abort on error.
"   1.00.001	22-Jan-2013	file creation

function! PatternsOnText#Selected#CreateAnswers( argument )
    let [l:cnt, l:answers, l:repeatedAnswers] = [0, '', '']

    for l:item in split(a:argument, ',\|[yn]\zs')
	if empty(l:item)
	    continue
	elseif l:item =~# '^[yn]$'
	    let l:answers .= l:item
	    let l:repeatedAnswers .= l:item
	    let l:cnt += 1
	elseif l:item =~# '^\d\+[yn]$'
	    let l:repeat = str2nr(l:item[0:-2])
	    let l:answers .= repeat(l:item[-1:-1], l:repeat)
	    let l:repeatedAnswers .= repeat(l:item[-1:-1], l:repeat)
	    let l:cnt += l:repeat
	elseif l:item =~# '^\d\+$' && l:item !~# '^0\+$'
	    if l:item <= l:cnt
		throw printf('PatternsOnText: Preceding position %s after position %d', l:item, l:cnt)
	    endif
	    let l:repeat = l:item - l:cnt - 1
	    let l:answers .= repeat('n', l:repeat) . 'y'
	    let l:repeatedAnswers = ''
	    let l:cnt = l:item
	elseif l:item =~# '^\d\+-\d\+$'
	    let [l:start, l:end] = matchlist(l:item, '^\(\d\+\)-\(\d\+\)$')[1:2]
	    if l:start > l:end
		throw printf('PatternsOnText: Invalid position range "%s"', l:item)
	    elseif l:start <= l:cnt
		throw printf('PatternsOnText: Preceding position %s after position %d', l:item, l:cnt)
	    endif
	    let l:repeat = l:start - l:cnt - 1
	    let l:answers .= repeat('n', l:repeat) . repeat('y', l:end - l:start + 1)
	    let l:repeatedAnswers = ''
	    let l:cnt = l:end
	elseif l:item =~# '^-\d\+$'
	    let l:end = l:item[1:]
	    if l:end <= l:cnt
		throw printf('PatternsOnText: Preceding position %s after position %d', l:end, l:cnt)
	    endif
	    let l:answers .= repeat('y', l:end - l:cnt)
	    let l:repeatedAnswers = ''
	    let l:cnt = l:end
	elseif l:item =~# '^\d\+-$'
	    let l:start = l:item[0:-2]
	    if l:start <= l:cnt
		throw printf('PatternsOnText: Preceding position %s after position %d', l:start, l:cnt)
	    endif
	    let l:repeat = l:start - l:cnt - 1
	    let l:answers .= repeat('n', l:repeat) . repeat('y', 999)
	    let l:repeatedAnswers = 'y'
	    let l:cnt = 999
	else
	    throw printf('PatternsOnText: Invalid position "%s"', l:item)
	endif
    endfor
    return [l:answers, l:repeatedAnswers]
endfunction
function! PatternsOnText#Selected#GetAnswer( answers, count )
    let l:index = a:count - 1
    let [l:answers, l:repeatedAnswers] = a:answers

    if empty(l:repeatedAnswers) || l:index < len(l:answers)
	return (l:answers[l:index] ==# 'y')
    else
	let l:repeatIndex = (l:index - len(l:answers)) % len(l:repeatedAnswers)
	return (l:repeatedAnswers[l:repeatIndex] ==# 'y')
    endif
endfunction

function! PatternsOnText#Selected#CountedReplace()
    let s:SubstituteSelected.count += 1
    let l:isSelected = PatternsOnText#Selected#GetAnswer(s:SubstituteSelected.answers, s:SubstituteSelected.count)

    if l:isSelected
	if s:SubstituteSelected.replacement =~# '^\\='
	    " Handle sub-replace-special.
	    return eval(s:SubstituteSelected.replacement[2:])
	else
	    " Handle & and \0, \1 .. \9 (but not \u, \U, \n, etc.)
	    let l:replacement = s:SubstituteSelected.replacement
	    for l:submatch in range(0, 9)
		let l:replacement = substitute(l:replacement,
		\   '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!' .
		\       (l:submatch == 0 ?
		\           '\%(&\|\\'.l:submatch.'\)' :
		\           '\\' . l:submatch
		\       ),
		\   submatch(l:submatch), 'g'
		\)
	    endfor
	    return l:replacement
	endif
    else
	return submatch(0)
    endif
endfunction
function! PatternsOnText#Selected#Substitute( range, arguments )
    let l:matches = matchlist(a:arguments, '^\(\i\@!\S\)\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(\S*\)\s\+\([-,[:digit:]yn]\+\)$')
    if empty(l:matches)
	call ingo#err#Set('Invalid arguments')
	return 0
    endif
    let s:SubstituteSelected = {'count': 0}
    let [l:separator, l:pattern, s:SubstituteSelected.replacement, l:flags] = l:matches[1:4]
    let s:SubstituteSelected.answers = PatternsOnText#Selected#CreateAnswers(l:matches[5])
"****D echomsg '****' string([l:separator, l:pattern, s:SubstituteSelected.replacement, l:flags, s:SubstituteSelected.answers])
    try
	execute printf('%ssubstitute %s%s%s\=PatternsOnText#Selected#CountedReplace()%s%s',
	\   a:range, l:separator, l:pattern, l:separator, l:separator, l:flags
	\)
	return 1
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
