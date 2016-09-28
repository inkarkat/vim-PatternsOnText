" PatternsOnText/If.vim: Commands to substitute if a predicate matches.
"
" DEPENDENCIES:
"
" Copyright: (C) 2016 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.60.001	28-Sep-2016	file creation

let s:previousPattern = ''
let s:previousPredicateExpr = ''
let s:previousReplacement = ''
function! PatternsOnText#If#Substitute( range, arguments, ... )
    call ingo#err#Clear()
    let s:SubstituteIf = {'count': 0, 'lastLnum': line('.')}
    let [l:separator, l:pattern, l:replacement, l:flags, l:predicateExpr] =
    \   ingo#cmdargs#substitute#Parse(a:arguments, {'flagsExpr': '\(&\?[cegiInp#lr]*\)\%(\s*$\|\%(^\|\s\+\)\(.*\)\)', 'flagsMatchCount': 2, 'emptyFlags': ['&', s:previousPredicateExpr], 'emptyPattern': s:previousPattern})
    if empty(l:predicateExpr)
	call ingo#err#Set('Missing predicate')
	return 0
    endif
    let s:previousPattern = escape(ingo#escape#Unescape(l:pattern, l:separator), '/')
    let s:previousPredicateExpr = l:predicateExpr
    let s:SubstituteIf.replacement = PatternsOnText#EmulatePreviousReplacement(l:replacement, s:previousReplacement)
    let s:previousReplacement = s:SubstituteIf.replacement

    try
"****D echomsg '****' string([l:separator, l:pattern, l:replacement, l:flags, l:predicateExpr])
	execute printf('%s%s %s%s%s\=s:Replace()%s%s',
	\   a:range, (a:0 ? a:1 : 'substitute'),
	\   l:separator, l:pattern, l:separator, l:separator, l:flags
	\)

	" :substitute has visited all further matches, but the last replacement
	" may have happened before that. Position the cursor on the last
	" actually selected match.
	execute s:SubstituteIf.lastLnum . 'normal! ^'

	if has_key(s:SubstituteIf, 'error')
	    call ingo#err#Set(s:SubstituteIf.error)
	    return 0
	endif
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    catch /^PatternsOnText:/
	call ingo#err#SetCustomException('PatternsOnText')
	return 0
    endtry
endfunction
function! s:Replace()
    if has_key(s:SubstituteIf, 'error')
	" Short-circuit all further errors; printing the predicate error once is
	" enough.
	return submatch(0)
    endif

    let s:SubstituteIf.count += 1
    try
	let l:isSelected = eval(s:previousPredicateExpr)
    catch /^Vim\%((\a\+)\)\=:/
	let s:SubstituteIf.error = ingo#msg#MsgFromVimException()
	return submatch(0)
    endtry

    if l:isSelected
	let s:SubstituteIf.lastLnum = line('.')
	if s:SubstituteIf.replacement =~# '^\\='
	    " Handle sub-replace-special.
	    return eval(s:SubstituteIf.replacement[2:])
	else
	    " Handle & and \0, \1 .. \9, and \r\n\t\b (but not \u, \U, etc.)
	    return PatternsOnText#ReplaceSpecial('', s:SubstituteIf.replacement, '\%(&\|\\[0-9rnbt]\)', function('PatternsOnText#Selected#ReplaceSpecial'))
	endif
    else
	return submatch(0)
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
