" PatternsOnText.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - ingo/msg.vim autoload script
"   - ingocmdargs.vim autoload script
"   - ingocollections.vim autoload script
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	22-Jan-2013	file creation

let s:SubstituteInSearch_PreviousArgs = []
function! PatternsOnText#InSearch#Substitute( firstLine, lastLine, substitutionArgs ) range
    let l:matches = matchlist(a:substitutionArgs, '^\(\i\@!\S\)\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(\S*\)\(\s\+\S.*\)\?')
    if empty(l:matches)
	if empty(s:SubstituteInSearch_PreviousArgs)
	    call ingo#msg#ErrorMsg('No previous substitute in search')
	    return
	endif

	let [l:separator, l:pattern, l:replacement] = s:SubstituteInSearch_PreviousArgs
	let l:matches = matchlist(a:substitutionArgs, '\(\S*\)\(\s\+\S.*\)\?')
	let [l:flags, l:count] = l:matches[1:2]
    else
	let [l:separator, l:pattern, l:replacement, l:flags, l:count] = l:matches[1:5]
    endif
"****D echomsg '****' string([l:separator, l:pattern, l:replacement, l:flags, l:count])

    " substitute() doesn't support the ~ special character to recall the last
    " substitution text; emulate this from our own history.
    let l:previousReplacementExpr = (&magic ? '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\~' : '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\\~')
    if l:replacement =~# l:previousReplacementExpr
	let l:replacement = substitute(l:replacement, l:previousReplacementExpr, escape(get(s:SubstituteInSearch_PreviousArgs, -1, ''), '\'), 'g')
    endif

    " Save substitution arguments for recall.
    let s:SubstituteInSearch_PreviousArgs = [l:separator, l:pattern, l:replacement]

    " Handle custom substitution flags.
    let l:substFlags = 'g'
    if l:flags =~# 'f'
	let l:substFlags = ''
	let l:flags = substitute(l:flags, 'f', '', 'g')
    endif

    try
	" The separation character must not appear (unescaped) in the expression, so
	" we use the original separator.
	execute printf('%d,%dsubstitute %s%s\=substitute(submatch(0), %s, %s, %s)%s%s%s',
	\   a:firstLine, a:lastLine,
	\   l:separator, l:separator,
	\   string(l:pattern),
	\   string(l:replacement),
	\   string(l:substFlags),
	\   l:separator,
	\   l:flags,
	\   l:count
	\)
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#msg#VimExceptionMsg()
    endtry
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
