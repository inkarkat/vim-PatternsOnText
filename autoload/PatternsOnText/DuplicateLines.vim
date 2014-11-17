" PatternsOnText/DuplicateLines.vim: Commands to work on duplicate lines.
"
" DEPENDENCIES:
"   - ingo/cmdargs/pattern.vim autoload script
"   - ingo/collections.vim autoload script
"
" Copyright: (C) 2013-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.36.009	23-Sep-2014	BUG: :.DeleteDuplicateLines... et al. don't work
"				correctly on a closed fold; need to use
"				ingo#range#NetStart().
"   1.36.008	29-May-2014	Refactoring: Use
"				ingo#cmdargs#pattern#ParseUnescaped().
"   1.30.007	10-Mar-2014	Extract PatternsOnText#DeleteLines().
"   1.30.006	05-Mar-2014	Extract s:DeleteLines() and use in new
"				PatternsOnText#DuplicateLines#DeleteAllLines()
"				which implements the new
"				:DeleteAllDuplicateLinesIgnoring command.
"				CHG: Don't ignore empty lines, but put them into
"				the accumulator as ^@ ("\n"). Empty lines now
"				need to be explicitly ignored, e.g. via /^$/
"				pattern.
"   1.02.005	01-Jun-2013	Move functions from ingo/cmdargs.vim to
"				ingo/cmdargs/pattern.vim and
"				ingo/cmdargs/substitute.vim.
"   1.00.004	28-May-2013	Add the pattern to the search history, like
"				:substitute, :global, etc. Because we're not
"				invoking :substitute here, we have to do this
"				explicitly.
"				ENH: Print the customary summary when deleting
"				duplicate lines.
"	003	21-Feb-2013	Move to ingo-library.
"	002	29-Jan-2013	Change ingocmdargs#UnescapePatternArgument() to
"				take the result of
"				ingocmdargs#ParsePatternArgument() instead of
"				invoking that function itself.
"	001	22-Jan-2013	file creation

function! PatternsOnText#DuplicateLines#PatternOrCurrentLine( arguments )
    if empty(a:arguments)
	return '\V\C\^' . escape(getline('.'), '\') . '\$'
    else
	return ingo#cmdargs#pattern#ParseUnescaped(a:arguments)
    endif
endfunction
function! s:FilterDuplicateLines( accumulator )
    call filter(a:accumulator, 'len(v:val) > 1')
endfunction
function! PatternsOnText#DuplicateLines#Process( startLnum, endLnum, ignorePattern, acceptPattern, Action )
    let l:ignorePattern = ingo#cmdargs#pattern#ParseUnescaped(a:ignorePattern)
"****D echomsg '****' string(l:ignorePattern) string(a:acceptPattern)
    " Add the pattern to the search history, like :substitute, :global, etc.
    for l:pattern in filter([l:ignorePattern, a:acceptPattern], '! empty(v:val)')
	call histadd('search', l:pattern)
    endfor

    let l:accumulator = {}
    for l:lnum in range(ingo#range#NetStart(a:startLnum), ingo#range#NetEnd(a:endLnum))
	let l:line = getline(l:lnum)
	if ! empty(a:acceptPattern) && l:line !~ a:acceptPattern
	    continue
	endif

	if ! empty(l:ignorePattern)
	    let l:wasEmpty = empty(l:line)
	    let l:line = substitute(l:line, l:ignorePattern, '', 'g')
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
    call s:FilterDuplicateLines(l:accumulator)

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
	    if len(a:accumulator) > 1
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
