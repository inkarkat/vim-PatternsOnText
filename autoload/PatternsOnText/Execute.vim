" PatternsOnText/Execute.vim: Commands to substitute with the result of evaluating an expression.
"
" DEPENDENCIES:
"   - ingo/action.vim autoload script
"   - ingo/cmdargs/pattern.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/escape.vim autoload script
"   - ingo/msg.vim autoload script
"
" Copyright: (C) 2016 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   2.00.002	30-Sep-2016	Refactoring: Factor out
"				PatternsOnText#InitialContext().
"   2.00.001	29-Sep-2016	file creation from If.vim

function! s:Parse( arguments )
    let l:flagsAndExprPattern = '\(&\?[cegiInp#lr]*\)\%(\s*$\|\%(^\|\s\+\)\(.*\)\)'
    let l:match = ingo#cmdargs#pattern#RawParse(a:arguments, [], l:flagsAndExprPattern, 2)
    if ! empty(l:match)
	return l:match
    endif

    " Parse the flags and expression ourselves.
    let [l:flags, l:expr] = matchlist(a:arguments, l:flagsAndExprPattern)[1:2]
    return ['/', '', l:flags, l:expr]
endfunction
let s:previousPattern = ''
let s:previousExpr = ''
function! PatternsOnText#Execute#Substitute( range, arguments, ... )
    call ingo#err#Clear()
    let s:SubstituteExecute = PatternsOnText#InitialContext()
    let [l:separator, l:pattern, l:flags, l:expr] = s:Parse(a:arguments)
    if empty(l:expr)
	let l:expr = s:previousExpr
    endif
    if l:flags ==# a:arguments
	" Recall previous flags
	if empty(l:flags)
	    let l:flags = '&'
	endif
    endif
    if empty(l:pattern)
	let l:pattern = s:previousPattern
    endif

    if empty(l:expr)
	call ingo#err#Set('Missing expression')
	return 0
    endif
    let s:previousPattern = escape(ingo#escape#Unescape(l:pattern, l:separator), '/')
    let s:previousExpr = l:expr
    let l:hasValReferenceInExpr = (l:expr =~# ingo#actions#GetValExpr())

    try
"****D echomsg '****' string([l:separator, l:pattern, l:flags, l:expr])
	execute printf('%s%s %s%s%s\=s:Replace(%d)%s%s',
	\   a:range, (a:0 ? a:1 : 'substitute'),
	\   l:separator, l:pattern, l:separator, l:hasValReferenceInExpr, l:separator, l:flags
	\)

	" :substitute has visited all further matches, but the last replacement
	" may have happened before that. Position the cursor on the last
	" actually selected match.
	execute s:SubstituteExecute.lastLnum . 'normal! ^'

	if has_key(s:SubstituteExecute, 'error')
	    call ingo#err#Set(s:SubstituteExecute.error)
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
function! s:Replace( hasValReferenceInExpr )
    if has_key(s:SubstituteExecute, 'error')
	" Short-circuit all further errors; printing the expression error once is
	" enough.
	return submatch(0)
    endif

    let s:SubstituteExecute.matchCount += 1
    try
	let l:expr = (a:hasValReferenceInExpr ? substitute(s:previousExpr, '\C' . ingo#actions#GetValExpr(), 'a:context', 'g') : s:previousExpr)
	let l:replacement = s:Invoke(l:expr, s:SubstituteExecute)

	if l:replacement !=# submatch(0)
	    let s:SubstituteExecute.replacementCount += 1
	    let s:SubstituteExecute.lastLnum = line('.')
	endif

	return l:replacement
    catch /^Vim\%((\a\+)\)\=:/
	let s:SubstituteExecute.error = ingo#msg#MsgFromVimException()
	return submatch(0)
    catch
	let s:SubstituteExecute.error = 'Expression threw exception: ' . v:exception
	return submatch(0)
    endtry
endfunction
function! s:Invoke( expr, context )
    execute a:expr
    return submatch(0)  " Default replacement is no-op.
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
