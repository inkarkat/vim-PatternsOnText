" PatternsOnText/Translate.vim: Commands to translate each unique match to a fixed item.
"
" DEPENDENCIES:
"   - PatternsOnText.vim autoload script
"   - ingo/actions.vim autoload script
"   - ingo/cmdargs/substitute.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/escape.vim autoload script
"   - ingo/funcref.vim autoload script
"   - ingo/lists.vim autoload script
"   - ingo/msg.vim autoload script
"
" Copyright: (C) 2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

let s:previousPattern = ''
let s:previousIsCaseInsensitive = 0
let s:previousTranslation = ''
let s:previousItems = []
let s:items = []
let s:memoizedTranslations = {}
let s:SubstituteTranslate = PatternsOnText#InitialContext()
function! PatternsOnText#Translate#Substitute( range, isClearAssociations, arguments, ... )
    call ingo#err#Clear()

    if a:isClearAssociations
	let s:items = []
	let s:memoizedTranslations = {}
	let s:SubstituteTranslate = PatternsOnText#InitialContext()
    endif

    let [l:separator, l:pattern, l:translationString, l:flags, l:count] =
    \   ingo#cmdargs#substitute#Parse(a:arguments, {'emptyFlags': ['', ''], 'emptyPattern': s:previousPattern})
    if empty(l:pattern)
	let l:pattern = s:previousPattern
    endif

    if l:flags . l:count ==# a:arguments
	" Recall previous translation.
	if empty(l:flags)
	    let l:flags = '&'
	elseif l:flags =~# 'i'
	    let s:previousIsCaseInsensitive = 1
	endif
    else
	" The original parsing groups {string1}/{string2} into l:replacement.
	let l:items = split(l:translationString, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\V' . l:separator)
	call map(l:items, 'ingo#escape#Unescape(v:val, "\\" . l:separator)')

	if len(l:items) > 1
	    " {item1}/{item2}[/...]
	    let l:translation = 's:FromItems()'
	    if ingo#lists#StartsWith(l:items, s:previousItems)
		" Add only new items that are appended after the previously
		" given ones. Do not override s:items with l:items as some items
		" likely already have been taken.
		let s:items += l:items[len(s:previousItems) :]
	    else
		let s:items += l:items
	    endif
	    let s:previousItems = copy(l:items)
	elseif empty(l:translationString)
	    " Recall previous translation.
	    let l:translation = s:previousTranslation
	elseif l:translationString =~# '^\\='
	    " \={expr}
	    let l:translation = l:translationString[2:]
	else
	    " {func}
	    let l:translation = ingo#funcref#ToString(l:translationString) . '(a:context)'
	endif

	let s:previousPattern = escape(ingo#escape#Unescape(l:pattern, l:separator), '/')
	let s:previousIsCaseInsensitive = (l:flags =~# 'i')
	let s:previousTranslation = l:translation
    endif

    if empty(s:previousTranslation)
	call ingo#err#Set('Missing {expr}/{func}/{item1}...')
	return 0
    endif

    let s:SubstituteTranslate.missingItems = {}
    let s:previousPattern = escape(ingo#escape#Unescape(l:pattern, l:separator), '/')
    let l:hasValReferenceInTranslation = (s:previousTranslation =~# ingo#actions#GetValExpr())

    try
"****D echomsg '****' string([l:separator, l:pattern, l:flags, s:previousTranslation])
	execute printf('%s%s %s%s%s\=s:Replace(%d)%s%s',
	\   a:range, (a:0 ? a:1 : 'substitute'),
	\   l:separator, l:pattern, l:separator, l:hasValReferenceInTranslation, l:separator, l:flags
	\)

	" :substitute has visited all further matches, but the last replacement
	" may have happened before that. Position the cursor on the last
	" actually translated match.
	execute s:SubstituteTranslate.lastLnum . 'normal! ^'

	if has_key(s:SubstituteTranslate, 'error')
	    call ingo#err#Set(s:SubstituteTranslate.error)
	    return 0
	elseif len(s:SubstituteTranslate.missingItems) > 0
	    call ingo#err#Set(printf('Incomplete substitution: Need %d more items', len(s:SubstituteTranslate.missingItems)))
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
function! s:Replace( hasValReferenceInTranslation )
    let l:match = submatch(0)
    let l:matchKey = (s:previousIsCaseInsensitive ? tolower(l:match) : l:match)
    if has_key(s:memoizedTranslations, l:matchKey)
	return s:ReplaceReturn(l:match, s:memoizedTranslations[l:matchKey])
    endif

    if has_key(s:SubstituteTranslate, 'error')
	" Short-circuit all further errors; printing the expression error once is
	" enough.
	return l:match
    endif

    let s:SubstituteTranslate.matchCount += 1
    try
	let l:translation = (a:hasValReferenceInTranslation ?
	\   substitute(s:previousTranslation, '\C' . ingo#actions#GetValExpr(), 'a:context', 'g') :
	\   s:previousTranslation
	\)
	let l:replacement = s:Invoke(l:translation, s:SubstituteTranslate)
"****D echomsg '****' string(l:matchKey) '=>' string(l:replacement)
	if type(l:replacement) == type([])
	    " A List indicates that no replacement is available.
	    let s:SubstituteTranslate.missingItems[l:matchKey] = 1
	    return l:match
	endif
	let s:memoizedTranslations[l:matchKey] = l:replacement
	return s:ReplaceReturn(l:match, l:replacement)
    catch /^Vim\%((\a\+)\)\=:/
	let s:SubstituteTranslate.error = ingo#msg#MsgFromVimException()
	return l:match
    catch
	let s:SubstituteTranslate.error = 'Expression threw exception: ' . v:exception
	return l:match
    endtry
endfunction
function! s:ReplaceReturn( match, replacement )
    if a:replacement !=# a:match
	let s:SubstituteTranslate.replacementCount += 1
	let s:SubstituteTranslate.lastLnum = line('.')
    endif

    return a:replacement
endfunction
function! s:Invoke( expr, context )
    execute 'return' a:expr
    return submatch(0)  " Default replacement is no-op.
endfunction

function! s:FromItems()
    return (empty(s:items) ? [] : remove(s:items, 0))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
