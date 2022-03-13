" PatternsOnText/Selected.vim: Commands to substitute only selected matches.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2011-2022 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! PatternsOnText#Selected#CreateAnswers( argument )
    let [l:cnt, l:answers, l:repeatedAnswers] = [0, '', '']

    for l:item in split(a:argument, ',\|[yn]\zs')
	if empty(l:item)
	    continue
	elseif l:item =~# '^[yn]$'
	    let l:answers .= l:item
	    let l:repeatedAnswers .= l:item
	    let l:cnt += 1
	elseif l:item =~# '^\d\+[yn]$'
	    let l:repeat = str2nr(l:item[0:-2])
	    let l:answers .= repeat(l:item[-1:-1], l:repeat)
	    let l:repeatedAnswers .= repeat(l:item[-1:-1], l:repeat)
	    let l:cnt += l:repeat
	elseif l:item =~# '^\d\+$' && l:item !~# '^0\+$'
	    if l:item <= l:cnt
		throw printf('PatternsOnText: Preceding position %s after position %d', l:item, l:cnt)
	    endif
	    let l:repeat = l:item - l:cnt - 1
	    let l:answers .= repeat('n', l:repeat) . 'y'
	    let l:repeatedAnswers = ''
	    let l:cnt = l:item
	elseif l:item =~# '^\d\+-\d\+$'
	    let [l:start, l:end] = matchlist(l:item, '^\(\d\+\)-\(\d\+\)$')[1:2]
	    if l:start > l:end
		throw printf('PatternsOnText: Invalid position range "%s"', l:item)
	    elseif l:start <= l:cnt
		throw printf('PatternsOnText: Preceding position %s after position %d', l:item, l:cnt)
	    endif
	    let l:repeat = l:start - l:cnt - 1
	    let l:answers .= repeat('n', l:repeat) . repeat('y', l:end - l:start + 1)
	    let l:repeatedAnswers = ''
	    let l:cnt = l:end
	elseif l:item =~# '^-\d\+$'
	    let l:end = l:item[1:]
	    if l:end <= l:cnt
		throw printf('PatternsOnText: Preceding position %s after position %d', l:end, l:cnt)
	    endif
	    let l:answers .= repeat('y', l:end - l:cnt)
	    let l:repeatedAnswers = ''
	    let l:cnt = l:end
	elseif l:item =~# '^\d\+-$'
	    let l:start = l:item[0:-2]
	    if l:start <= l:cnt
		throw printf('PatternsOnText: Preceding position %s after position %d', l:start, l:cnt)
	    endif
	    let l:repeat = l:start - l:cnt - 1
	    let l:answers .= repeat('n', l:repeat) . repeat('y', 999)
	    let l:repeatedAnswers = 'y'
	    let l:cnt = 999
	else
	    throw printf('PatternsOnText: Invalid position "%s"', l:item)
	endif
    endfor
    return [l:answers, l:repeatedAnswers]
endfunction
function! PatternsOnText#Selected#GetAnswer( answers, count )
    let l:index = a:count - 1
    let [l:answers, l:repeatedAnswers] = a:answers

    if empty(l:repeatedAnswers) || l:index < len(l:answers)
	return (l:answers[l:index] ==# 'y')
    else
	let l:repeatIndex = (l:index - len(l:answers)) % len(l:repeatedAnswers)
	return (l:repeatedAnswers[l:repeatIndex] ==# 'y')
    endif
endfunction

function! PatternsOnText#Selected#CountedReplace()
    let s:SubstituteSelected.count += 1
    let l:isSelected = PatternsOnText#Selected#GetAnswer(s:SubstituteSelected.answers, s:SubstituteSelected.count)

    return ingo#subst#replacement#DefaultReplacementOnPredicate(l:isSelected, s:SubstituteSelected)
endfunction
let s:previousReplacement = ''
let s:previousAnswers = ''
function! PatternsOnText#Selected#Parse( arguments, previousAnswers, ... )
    let l:additionalFlags = (a:0 ? a:1 : '')
    let l:answersExpr = '\-,[:space:][:digit:]yn' . l:additionalFlags
    let [l:separator, l:pattern, l:replacement, l:flags, l:count] =
    \   ingo#cmdargs#substitute#Parse(a:arguments, {'additionalFlags': l:answersExpr, 'emptyFlags': ['', '']})  " Because of the more complex defaulting of the two different :s_flags and answers, we handle this ourselves.
    " Note: l:count is always empty, as whitespace + digits are already matched
    " by our additional flags, and that takes precedence.
    " Note: Must not include the built-in :s_n flag, as this is one of the
    " possible answers, and must be included there.
    let [l:substituteFlags, l:parsedAnswers] = matchlist(l:flags, '\C^\(&\?[cegiIp#lr' . l:additionalFlags . ']*\)\s*\([' . l:answersExpr . ']*\)$')[1:2]
    " Use previous answers only for the :SubstituteSelected [flags] [answers]
    " form, not when a /{pattern} is passed; it's too easy to forget the
    " required answers and then be surprised when the ones from the previous
    " unrelated :SubstituteSelected are used.
    let l:answers = (empty(l:parsedAnswers) && a:arguments ==# l:substituteFlags ? a:previousAnswers : l:parsedAnswers)
    if a:arguments ==# l:parsedAnswers
	" Only {answers} are given on this command repeat. Use the :s_flags from
	" the previous :substitute.
	let l:substituteFlags = '&'
    endif

    return [l:separator, l:pattern, l:replacement, l:substituteFlags, l:answers]
endfunction
function! PatternsOnText#Selected#Substitute( mods, range, arguments, ... )
    call ingo#err#Clear()
    let s:SubstituteSelected = {'count': 0, 'lastLnum': line('.')}
    let [l:separator, l:pattern, l:replacement, l:substituteFlags, l:answers] = PatternsOnText#Selected#Parse(a:arguments, s:previousAnswers)
    if empty(l:answers)
	call ingo#err#Set('Missing or invalid answers')
	return 0
    endif

    let s:previousAnswers = l:answers
    let s:SubstituteSelected.replacement = PatternsOnText#EmulatePreviousReplacement(l:replacement, s:previousReplacement)
    let s:previousReplacement = s:SubstituteSelected.replacement

    try
	let s:SubstituteSelected.answers = PatternsOnText#Selected#CreateAnswers(l:answers)
"****D echomsg '****' string([l:separator, l:pattern, s:SubstituteSelected.replacement, l:substituteFlags, l:answers, s:SubstituteSelected.answers])
	execute printf('%s %s%s %s%s%s\=PatternsOnText#Selected#CountedReplace()%s%s',
	\   a:mods, a:range, (a:0 ? a:1 : 'substitute'),
	\   l:separator, l:pattern, l:separator, l:separator, l:substituteFlags
	\)

	" :substitute has visited all further matches, but the last replacement
	" may have happened before that. Position the cursor on the last
	" actually selected match.
	execute s:SubstituteSelected.lastLnum . 'normal! ^'
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    catch /^PatternsOnText:/
	call ingo#err#SetCustomException('PatternsOnText')
	return 0
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
