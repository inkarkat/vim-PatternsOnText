" PatternsOnText/InSearch.vim: Advanced commands to apply regular expressions.
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
"   1.00.003	28-May-2013	Use ingo#msg#StatusMsg().
"				Replace the custom parsing with the (extended
"				new) parsing of
"				ingo#cmdargs#ParseSubstituteArgument().
"   1.00.002	06-Mar-2013	Print :substitute-like summary for the inner
"				substitutions instead of the rather meaningless
"				default summary from the outer :substitute
"				command.
"	001	22-Jan-2013	file creation
let s:save_cpo = &cpo
set cpo&vim

function! PatternsOnText#InSearch#InnerSubstitute( expr, pat, sub, flags )
    let s:didInnerSubstitution = 1
    let l:replacement = substitute(a:expr, a:pat, a:sub, a:flags)
    if a:expr !=# l:replacement
	let s:innerSubstitutionCnt += 1
	let s:innerSubstitutionLnums[line('.')] = 1
    endif
    return l:replacement
endfunction
let s:previousPattern = ''
let s:previousReplacement = ''
function! PatternsOnText#InSearch#Substitute( firstLine, lastLine, arguments ) range
    let [l:separator, l:pattern, l:replacement, l:flags, l:count] =
    \   ingo#cmdargs#ParseSubstituteArgument(a:arguments, '\(\S*\)\(\s\+\S.*\)\?', {'flagsMatchCount': 2, 'emptyPattern': s:previousPattern})

    " substitute() doesn't support the ~ special character to recall the last
    " substitution text; emulate this from our own history.
    let l:previousReplacementExpr = (&magic ? '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\~' : '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\\~')
    if l:replacement =~# l:previousReplacementExpr
	let l:replacement = substitute(l:replacement, l:previousReplacementExpr, escape(s:previousReplacement, '\'), 'g')
    endif
    let s:previousPattern = l:pattern
    let s:previousReplacement = l:replacement

    " Handle custom substitution flags.
    let l:substFlags = 'g'
    if l:flags =~# 'f'
	let l:substFlags = ''
	let l:flags = substitute(l:flags, 'f', '', 'g')
    endif

    let s:didInnerSubstitution = 0
    let s:innerSubstitutionCnt = 0
    let s:innerSubstitutionLnums = {}
    try
	" Use :silent to suppress the default "M substitutions on N lines"
	" message. We print our own message giving information about the inner
	" substitutions.
	" The separation character must not appear (unescaped) in the expression, so
	" we use the original separator.
	silent execute printf('%d,%dsubstitute %s%s\=PatternsOnText#InSearch#InnerSubstitute(submatch(0), %s, %s, %s)%s%s%s',
	\   a:firstLine, a:lastLine,
	\   l:separator, l:separator,
	\   string(l:pattern),
	\   string(l:replacement),
	\   string(l:substFlags),
	\   l:separator,
	\   l:flags,
	\   l:count
	\)

	if s:didInnerSubstitution && s:innerSubstitutionCnt == 0 && l:flags !~# 'e'
	    call ingo#msg#ErrorMsg('Pattern not found: ' . l:pattern)
	    return
	endif

	let l:innerSubstitutionLines = len(keys(s:innerSubstitutionLnums))
	if l:innerSubstitutionLines >= &report
	    call ingo#msg#StatusMsg(printf('%d substitution%s on %d line%s',
	    \   s:innerSubstitutionCnt, (s:innerSubstitutionCnt == 1 ? '' : 's'),
	    \   l:innerSubstitutionLines, (l:innerSubstitutionLines == 1 ? '' : 's')
	    \))
	endif
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#msg#VimExceptionMsg()
    finally
	unlet! s:didInnerSubstitution s:innerSubstitutionCnt s:innerSubstitutionLnums
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
