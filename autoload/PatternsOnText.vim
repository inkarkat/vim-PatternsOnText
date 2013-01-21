" PatternsOnText.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - ingocmdargs.vim autoload script
"   - ingocollections.vim autoload script
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	21-Jan-2013	file creation

function! s:ErrorMsg( text )
    let v:errmsg = a:text
    echohl ErrorMsg
    echomsg v:errmsg
    echohl None
endfunction
function! s:ExceptionMsg( exception )
    " v:exception contains what is normally in v:errmsg, but with extra
    " exception source info prepended, which we cut away.
    call s:ErrorMsg(substitute(a:exception, '^Vim\%((\a\+)\)\=:', '', ''))
endfunction



function! s:InvertedSubstitute( range, separator, pattern, replacement, flags )
    if empty(a:pattern)
	let l:separator = '/'
	let l:pattern = @/
    else
	let l:separator = a:separator
	let l:pattern = a:pattern
    endif

    try
	execute printf('%ssubstitute %s\%%(^\|%s\)\zs\%%(%s\)\@!.\{-1,}\ze\%%(%s\|$\)%s%s%s%s',
	\   a:range, l:separator, l:pattern, l:pattern, l:pattern, l:separator, a:replacement, l:separator, a:flags
	\)
    catch /^Vim\%((\a\+)\)\=:E/
	call s:ExceptionMsg(v:exception)
    endtry
endfunction
let s:SubstituteExcept_PreviousFlags = ''
function! PatternsOnText#SubstituteExcept( range, arguments )
    let l:matches = matchlist(a:arguments, '^\(\i\@!\S\)\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(\S*\)')
    if empty(l:matches)
	let [l:separator, l:pattern, l:replacement, l:flags] = ['/', '', '~', s:SubstituteExcept_PreviousFlags]
    else
	let [l:separator, l:pattern, l:replacement, l:flags, l:count] = l:matches[1:5]
	let s:SubstituteExcept_PreviousFlags = l:flags
    endif
"****D echomsg '****' string([l:separator, l:pattern, l:replacement, l:flags])
    call s:InvertedSubstitute(a:range, l:separator, l:pattern, l:replacement, l:flags)
endfunction
function! PatternsOnText#DeleteExcept( range, arguments )
    let [l:separator, l:pattern, l:flags] = ingocmdargs#ParsePatternArgument(a:arguments, '\(.*\)')

    call s:InvertedSubstitute(a:range, l:separator, l:pattern, '', 'g' . l:flags)
    call histdel('search', -1)
endfunction



function! PatternsOnText#CountedReplace()
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
function! PatternsOnText#SubstituteSelected( range, arguments )
    let l:matches = matchlist(a:arguments, '^\(\i\@!\S\)\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(\S*\)\s\+\([yn]\+\)$')
    if empty(l:matches)
	call s:ErrorMsg('Invalid arguments')
	return
    endif
    let s:SubstituteSelected = {'count': 0}
    let [l:separator, l:pattern, s:SubstituteSelected.replacement, l:flags, s:SubstituteSelected.answers] = l:matches[1:5]
"****D echomsg '****' string([l:separator, l:pattern, s:SubstituteSelected.replacement, l:flags, s:SubstituteSelected.answers])
    try
	execute printf('%ssubstitute %s%s%s\=PatternsOnText#CountedReplace()%s%s',
	\   a:range, l:separator, l:pattern, l:separator, l:separator, l:flags
	\)
    catch /^Vim\%((\a\+)\)\=:E/
	call s:ExceptionMsg(v:exception)
    endtry
endfunction

let s:SubstituteInSearch_PreviousArgs = []
function! PatternsOnText#SubstituteInSearch( firstLine, lastLine, substitutionArgs ) range
    let l:matches = matchlist(a:substitutionArgs, '^\(\i\@!\S\)\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(.*\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\(\S*\)\(\s\+\S.*\)\?')
    if empty(l:matches)
	if empty(s:SubstituteInSearch_PreviousArgs)
	    call s:ErrorMsg('No previous substitute in search')
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
	call s:ExceptionMsg(v:exception)
    endtry
endfunction



function! PatternsOnText#PatternOrCurrentLine( arguments )
    if empty(a:arguments)
	return '\V\C\^' . escape(getline('.'), '\') . '\$'
    else
	return ingocmdargs#UnescapePatternArgument(a:arguments)
    endif
endfunction
function! s:FilterDuplicateLines( accumulator )
    call filter(a:accumulator, 'len(v:val) > 1')
endfunction
function! PatternsOnText#ProcessDuplicateLines( startLnum, endLnum, ignorePattern, acceptPattern, Action )
    let l:ignorePattern = ingocmdargs#UnescapePatternArgument(a:ignorePattern)
"****D echomsg '****' string(l:ignorePattern) string(a:acceptPattern)
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
function! PatternsOnText#PrintLines( accumulator )
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
function! PatternsOnText#DeleteLines( accumulator )
    " Set a jump on the original position.
    normal! m'

    let l:deleteLnums = []

    " All but the first occurrence shall be deleted.
    for l:slotLnums in values(a:accumulator)
	call extend(l:deleteLnums, l:slotLnums[1:])
    endfor

    " Sort from last to first line to avoid adapting the line numbers.
    for l:lnum in reverse(sort(l:deleteLnums, 'ingocollections#numsort'))
	execute 'keepjumps' l:lnum . 'delete _'
    endfor

    " Position the cursor on the line after the last deletion, like
    " :g/.../delete does.
    execute (l:deleteLnums[0] - len(l:deleteLnums) + 1)
    normal! ^
endfunction

function! s:FilterDuplicates( accumulator )
    call filter(a:accumulator, 'v:val.cnt > 1')
endfunction
function! PatternsOnText#ProcessDuplicates( startLnum, endLnum, arguments, OnDuplicateAction, ReportAction )
    if empty(a:arguments)
	let [l:separator, l:pattern] = ['/', @/]
    else
	let [l:separator, l:pattern] = ingocmdargs#ParsePatternArgument(a:arguments)
    endif

    let l:accumulator = {}
    try
	execute printf('silent %d,%dsubstitute %s%s%s\=s:Collect(l:accumulator%s)%sg',
	\   a:startLnum, a:endLnum, l:separator, l:pattern, l:separator,
	\   (empty(a:OnDuplicateAction) ? '' : ', ' . string(a:OnDuplicateAction)),
	\   l:separator
	\)

	call s:FilterDuplicates(l:accumulator)
"****D echomsg '****' string(l:accumulator)
	if empty(l:accumulator)
	    return 0
	elseif ! empty(a:ReportAction)
	    call call(a:ReportAction, [l:accumulator, a:startLnum, a:endLnum])
	endif
    catch /^Vim\%((\a\+)\)\=:E/
	echomsg v:exception
	call s:ExceptionMsg(v:exception)
    endtry

    return 1
endfunction
function! s:Collect( accumulator, ... )
    let l:match = submatch(0)

    if empty(l:match)
	continue
    endif

    if ! has_key(a:accumulator, l:match)
	let a:accumulator[l:match] = {'cnt': 1, 'lnum': {line('.') : 1}, 'first': line('.')}
    else
	let a:accumulator[l:match].cnt += 1
	let a:accumulator[l:match].lnum[line('.')] = 1

	if a:0
	    let l:match = call(a:1, [a:accumulator, l:match])
	endif
    endif

    return l:match
endfunction
function! PatternsOnText#PrintMatches( accumulator, startLnum, endLnum )
    if a:startLnum == a:endLnum
	for l:what in sort(keys(a:accumulator))
	    echohl LineNr
	    echo a:startLnum
	    echohl None

	    echon ' '
	    echohl Directory
	    echon l:what
	    echohl None
	    echon ': ' . a:accumulator[l:what].cnt
	endfor
    else
	" List duplicates sorted by first occurrence.
	let l:byFirstOccurrence = {}
	for l:what in keys(a:accumulator)
	    let l:first = a:accumulator[l:what].first
	    if ! has_key(l:byFirstOccurrence, l:first)
		let l:byFirstOccurrence[l:first] = [l:what]
	    else
		call add(l:byFirstOccurrence[l:first], l:what)
	    endif
	endfor
"****D echomsg '****' string(l:byFirstOccurrence)
	for l:lnum in sort(keys(l:byFirstOccurrence), 'ingocollections#numsort')
	    for l:what in sort(l:byFirstOccurrence[l:lnum])
		echohl LineNr
		echo l:lnum
		echohl None

		echon ' '
		echohl Directory
		echon l:what
		echohl None
		echon ': ' . a:accumulator[l:what].cnt

		if len(a:accumulator[l:what].lnum) > 7
		    " We have duplicates distributed over many lines, add a
		    " summary.
		    echon printf(' in %d lines', len(a:accumulator[l:what].lnum))
		elseif len(a:accumulator[l:what].lnum) > 1
		    " We have duplicates over a few lines; list the all.
		    echon ' in '
		    echohl LineNr
		    echon join(sort(keys(a:accumulator[l:what].lnum), 'ingocollections#numsort'), ', ')
		    echohl None
		endif
	    endfor
	endfor
    endif
endfunction
function! PatternsOnText#DeleteMatches( accumulator, match )
    return ''
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
