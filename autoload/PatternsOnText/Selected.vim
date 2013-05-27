" PatternsOnText/Selected.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - ingo/msg.vim autoload script
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	22-Jan-2013	file creation

function! PatternsOnText#Selected#CountedReplace()
    let l:index = s:SubstituteSelected.count % len(s:SubstituteSelected.answers)
    let s:SubstituteSelected.count += 1

    if s:SubstituteSelected.answers[l:index] ==# 'y'
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
    elseif s:SubstituteSelected.answers[l:index] ==# 'n'
	return submatch(0)
    else
	throw 'ASSERT: Invalid answer: ' . string(s:SubstituteSelected.answers[l:index])
    endif
endfunction
function! PatternsOnText#Selected#Substitute( range, arguments )
    let l:matches = matchlist(a:arguments, '^\(\i\@!\S\)\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(\S*\)\s\+\([yn]\+\)$')
    if empty(l:matches)
	call ingo#msg#ErrorMsg('Invalid arguments')
	return
    endif
    let s:SubstituteSelected = {'count': 0}
    let [l:separator, l:pattern, s:SubstituteSelected.replacement, l:flags, s:SubstituteSelected.answers] = l:matches[1:5]
"****D echomsg '****' string([l:separator, l:pattern, s:SubstituteSelected.replacement, l:flags, s:SubstituteSelected.answers])
    try
	execute printf('%ssubstitute %s%s%s\=PatternsOnText#Selected#CountedReplace()%s%s',
	\   a:range, l:separator, l:pattern, l:separator, l:separator, l:flags
	\)
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#msg#VimExceptionMsg()
    endtry
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
