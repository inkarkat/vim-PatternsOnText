" PatternsOnText/DuplicateLines.vim: Commands to work on duplicate lines.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2013-2022 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! PatternsOnText#DuplicateLines#PatternOrCurrentLine( arguments )
    if empty(a:arguments)
	return '\V\C\^' . escape(getline('.'), '\') . '\$'
    else
	return ingo#cmdargs#pattern#ParseUnescaped(a:arguments)
    endif
endfunction
function! PatternsOnText#DuplicateLines#FilterDuplicateLines( accumulator )
    call filter(a:accumulator, 'len(v:val) > 1')
endfunction
function! PatternsOnText#DuplicateLines#FilterUniqueLines( accumulator )
    call filter(a:accumulator, 'len(v:val) == 1')
endfunction

function! s:Match( text, pattern, isInvert )
    execute 'return a:text' (a:isInvert ? '!~' : '=~') 'a:pattern'
endfunction
function! s:Extract( text, pattern, isInvert )
    if a:isInvert
	let l:matches = []
	call substitute(a:text, a:pattern, '\=empty(add(l:matches, submatch(0))) ? submatch(0) : submatch(0)', 'g')
	return join(l:matches, '')
    else
	return substitute(a:text, a:pattern, '', 'g')
    endif
endfunction
function! PatternsOnText#DuplicateLines#Process( startLnum, endLnum, ignorePattern, isIgnorePatternInverted, acceptPattern, isAcceptPatternInverted, Filter, Action )
    let l:ignorePattern = ingo#cmdargs#pattern#ParseUnescaped(a:ignorePattern)
"****D echomsg '****' string(l:ignorePattern) a:isIgnorePatternInverted string(a:acceptPattern) a:isAcceptPatternInverted
    " Add the pattern to the search history, like :substitute, :global, etc.
    for l:pattern in filter([l:ignorePattern, a:acceptPattern], '! empty(v:val)')
	call histadd('search', escape(l:pattern, '/'))
    endfor

    let l:accumulator = {}
    for l:lnum in range(ingo#range#NetStart(a:startLnum), ingo#range#NetEnd(a:endLnum))
	let l:line = getline(l:lnum)
	if ! empty(a:acceptPattern) && ! s:Match(l:line, a:acceptPattern, a:isAcceptPatternInverted)
	    continue
	endif

	if ! empty(l:ignorePattern)
	    let l:wasEmpty = empty(l:line)
	    let l:line = s:Extract(l:line, l:ignorePattern, a:isIgnorePatternInverted)
	    if empty(l:line) && (! l:wasEmpty || '' =~ l:ignorePattern)
		continue    " Filter out completely ignored lines.
	    endif
	endif

	if empty(l:line)
	    let l:line = "\n" " Dictionary keys mustn't be empty, so persist it as if it contained ^@.
	endif

	if ! has_key(l:accumulator, l:line)
	    let l:accumulator[l:line] = [l:lnum]
	else
	    call add(l:accumulator[l:line], l:lnum)
	endif
    endfor
"****D echomsg '****' string(l:accumulator)
    call call(a:Filter, [l:accumulator])

    if empty(l:accumulator)
	return 0
    else
	call call(a:Action, [l:accumulator])
    endif

    return 1
endfunction
function! s:CompareByFirstValue( i1, i2 )
    let l:v1 = a:i1[1][0]
    let l:v2 = a:i2[1][0]
    return l:v1 == l:v2 ? 0 : l:v1 > l:v2 ? 1 : -1
endfunction
function! PatternsOnText#DuplicateLines#PrintLines( accumulator )
    " Note: :number will print all lines in a closed fold; disable folding
    " first.
    let l:save_foldenable = &foldenable
    set nofoldenable
    try
	for [l:line, l:lnums] in sort(items(a:accumulator), 's:CompareByFirstValue')
	    if len(a:accumulator) > 1 && len(l:lnums) > 1
		echohl Directory
		echo (l:line ==# "\n" ? '' : l:line) |  " Empty lines are persisted as ^@.
		echohl None
	    endif
	    for l:lnum in l:lnums
		execute l:lnum . 'number'
	    endfor
	endfor
    finally
	let &foldenable = l:save_foldenable
    endtry
endfunction
function! s:DeleteLines( accumulator, isDeleteFirstLine )
    let l:deleteLnums = []

    for l:slotLnums in values(a:accumulator)
	call extend(l:deleteLnums, (a:isDeleteFirstLine ? l:slotLnums : l:slotLnums[1:]))
    endfor

    call PatternsOnText#DeleteLines(l:deleteLnums)
endfunction
function! PatternsOnText#DuplicateLines#DeleteSubsequentLines( accumulator )
    call s:DeleteLines(a:accumulator, 0)
endfunction
function! PatternsOnText#DuplicateLines#DeleteAllLines( accumulator )
    call s:DeleteLines(a:accumulator, 1)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
