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
"   1.01.002	30-May-2013	Implement abort on error.
"   1.00.001	22-Jan-2013	file creation

function! PatternsOnText#Selected#CreateAnswers( argument )
    if a:argument !~# '^[yn]\+$'
	throw 'ASSERT: Invalid answer in: ' . string(a:argument)
    endif
    return a:argument
endfunction
function! PatternsOnText#Selected#GetAnswer( answers, count )
    let l:index = (a:count - 1) % len(a:answers)
    return (a:answers[l:index] ==# 'y')
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
    let l:matches = matchlist(a:arguments, '^\(\i\@!\S\)\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(\S*\)\s\+\([yn]\+\)$')
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
