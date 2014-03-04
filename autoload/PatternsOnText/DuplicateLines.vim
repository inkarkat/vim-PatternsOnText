" PatternsOnText/DuplicateLines.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - ingo/cmdargs/pattern.vim autoload script
"   - ingo/collections.vim autoload script
"   - ingo/msg.vim autoload script
"
" Copyright: (C) 2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
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
	return ingo#cmdargs#pattern#Unescape(ingo#cmdargs#pattern#Parse(a:arguments))
    endif
endfunction
function! s:FilterDuplicateLines( accumulator )
    call filter(a:accumulator, 'len(v:val) > 1')
endfunction
function! PatternsOnText#DuplicateLines#Process( startLnum, endLnum, ignorePattern, acceptPattern, Action )
    let l:ignorePattern = ingo#cmdargs#pattern#Unescape(ingo#cmdargs#pattern#Parse(a:ignorePattern))
"****D echomsg '****' string(l:ignorePattern) string(a:acceptPattern)
    " Add the pattern to the search history, like :substitute, :global, etc.
    for l:pattern in filter([l:ignorePattern, a:acceptPattern], '! empty(v:val)')
	call histadd('search', l:pattern)
    endfor

    let l:accumulator = {}
    for l:lnum in range(a:startLnum, a:endLnum)
	let l:line = getline(l:lnum)
	if ! empty(a:acceptPattern) && l:line !~ a:acceptPattern
	    continue
	endif

	if ! empty(l:ignorePattern)
	    let l:line = substitute(l:line, l:ignorePattern, '', 'g')
	endif

	if empty(l:line)
	    continue
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
		echo l:line
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
function! PatternsOnText#DuplicateLines#DeleteLines( accumulator )
    " Set a jump on the original position.
    normal! m'

    let l:deleteLnums = []

    " All but the first occurrence shall be deleted.
    for l:slotLnums in values(a:accumulator)
	call extend(l:deleteLnums, l:slotLnums[1:])
    endfor

    " Sort from last to first line to avoid adapting the line numbers.
    for l:lnum in reverse(sort(l:deleteLnums, 'ingo#collections#numsort'))
	execute 'keepjumps' l:lnum . 'delete _'
    endfor

    " Position the cursor on the line after the last deletion, like
    " :g/.../delete does.
    execute (l:deleteLnums[0] - len(l:deleteLnums) + 1)
    normal! ^

    " Print a summary.
    if len(l:deleteLnums) > &report
	call ingo#msg#StatusMsg(printf('%d fewer line%s', len(l:deleteLnums), (len(l:deleteLnums) == 1 ? '' : 's')))
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
