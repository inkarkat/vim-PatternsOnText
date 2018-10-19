" PatternsOnText/If.vim: Commands to substitute if a predicate matches.
"
" DEPENDENCIES:
"   - PatternsOnText.vim autoload script
"   - ingo/action.vim autoload script
"   - ingo/cmdargs/substitute.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/escape.vim autoload script
"   - ingo/msg.vim autoload script
"   - ingo/subst/replacement.vim autoload script
"
" Copyright: (C) 2016-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

let s:previousPattern = ''
let s:previousIsNegate = 0
let s:previousPredicateExpr = ''
let s:previousReplacement = ''
function! PatternsOnText#If#Substitute( isNegate, range, arguments, ... )
    call ingo#err#Clear()
    let s:SubstituteIf = PatternsOnText#InitialContext()
    let [l:separator, l:pattern, l:replacement, l:flags, l:predicateExpr] =
    \   ingo#cmdargs#substitute#Parse(a:arguments, {'flagsExpr': '\(' . ingo#cmdargs#substitute#GetFlags() . '\)\%(\s*$\|\%(^\|\s\+\)\(.*\)\)', 'flagsMatchCount': 2, 'emptyFlags': ['&', s:previousPredicateExpr], 'emptyPattern': s:previousPattern})
    if empty(l:predicateExpr)
	call ingo#err#Set('Missing predicate')
	return 0
    endif
    let s:previousPattern = escape(ingo#escape#Unescape(l:pattern, l:separator), '/')
    let s:previousIsNegate = a:isNegate
    let s:previousPredicateExpr = l:predicateExpr
    let s:SubstituteIf.replacement = PatternsOnText#EmulatePreviousReplacement(l:replacement, s:previousReplacement)
    let s:previousReplacement = s:SubstituteIf.replacement
    let l:hasValReferenceInPredicate = (l:predicateExpr =~# ingo#actions#GetValExpr())

    try
"****D echomsg '****' string([l:separator, l:pattern, l:replacement, l:flags, l:predicateExpr])
	execute printf('%s%s %s%s%s\=s:Replace(%d)%s%s',
	\   a:range, (a:0 ? a:1 : 'substitute'),
	\   l:separator, l:pattern, l:separator, l:hasValReferenceInPredicate, l:separator, l:flags
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
function! s:Replace( hasValReferenceInPredicate )
    if has_key(s:SubstituteIf, 'error')
	" Short-circuit all further errors; printing the predicate error once is
	" enough.
	return submatch(0)
    endif

    let s:SubstituteIf.matchCount += 1
    try
	if a:hasValReferenceInPredicate
	    let l:isSelected = ingo#actions#EvaluateWithVal(s:previousPredicateExpr, s:SubstituteIf)
	else
	    let l:isSelected = eval(s:previousPredicateExpr)
	endif
	if s:previousIsNegate
	    let l:isSelected = ! l:isSelected
	endif

	if l:isSelected
	    let s:SubstituteIf.replacementCount += 1
	endif
    catch /^Vim\%((\a\+)\)\=:/
	let s:SubstituteIf.error = ingo#msg#MsgFromVimException()
	return submatch(0)
    endtry

    return ingo#subst#replacement#DefaultReplacementOnPredicate(l:isSelected, s:SubstituteIf)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
