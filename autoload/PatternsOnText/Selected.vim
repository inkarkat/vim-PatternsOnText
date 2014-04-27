" PatternsOnText/Selected.vim: Commands to substitute only selected matches.
"
" DEPENDENCIES:
"   - PatternsOnText.vim autoload script
"   - ingo/cmdargs/substitute.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/escape.vim autoload script
"
" Copyright: (C) 2011-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.30.012	12-Mar-2014	Handle \r, \n, \t, \b in replacement, too.
"   1.30.011	11-Mar-2014	Allow to pass additional substitute flags to
"				PatternsOnText#Selected#Parse(), used by
"				PatternsOnText/Subsequent.vim
"   1.21.010	05-Mar-2014	FIX: Need to escape '\\' in addition to the
"				passed a:expr (after the previous fix).
"   1.21.009	20-Feb-2014	FIX: Wrong use of ingo#escape#Unescape(); need
"				to unescape the \& or \\1 (to & or \1) via
"				substitute(), as the library function does not
"				take an expression.
"   1.20.008	17-Jan-2014	Replace the sequential expansion of &, \0, \1,
"				... with a single iteration, implemented in new
"				PatternsOnText#ReplaceSpecial(). Now, when \1
"				expands to \2, it is not mistakenly re-expanded
"				any more.
"   1.12.007	14-Jun-2013	Minor: Make matchlist() robust against
"				'ignorecase'.
"   1.11.006	12-Jun-2013	Factor out PatternsOnText#Selected#Parse().
"   1.11.005	11-Jun-2013	:SubstituteSelected now positions the cursor on
"				the line where the last selected replacement
"				happened, to behave like :substitute.
"				Allow to use :SmartCase substitution via new
"				optional argument to
"				PatternsOnText#Selected#Substitute().
"   1.10.004	06-Jun-2013	BUG: Because of substitute(), we have to handle
"				"&" ourselves. Remember the last replacement and
"				use factored out
"				PatternsOnText#EmulatePreviousReplacement().
"				BUG: Repeat :SubstituteSelected doesn't properly
"				pick up the default "&" flag, because our flags
"				are two-part. Let the parser default to empty
"				flags, and handle the defaulting (and recall of
"				previous answers) ourselves.
"				Also recall previous answers in a bare
"				:SubstituteSelected command.
"				Parsing must not include the built-in :s_n flag,
"				as this is one of the possible answers, and must
"				be included there.
"				More precise error message.
"   1.10.003	03-Jun-2013	Factor out
"				PatternsOnText#Selected#CreateAnswers() and
"				PatternsOnText#Selected#GetAnswer().
"				ENH: Handle count before "y" and "n" answers,
"				numeric positions "2,5", and ranges "3-5".
"				Use ingo#cmdargs#substitute#Parse() here, too.
"				This just requires a little bit of additional
"				parsing to separate the :s_flags from the
"				answers.
"   1.01.002	30-May-2013	Implement abort on error.
"   1.00.001	22-Jan-2013	file creation
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

    if l:isSelected
	let s:SubstituteSelected.lastLnum = line('.')
	if s:SubstituteSelected.replacement =~# '^\\='
	    " Handle sub-replace-special.
	    return eval(s:SubstituteSelected.replacement[2:])
	else
	    " Handle & and \0, \1 .. \9, and \r\n\t\b (but not \u, \U, etc.)
	    return PatternsOnText#ReplaceSpecial('', s:SubstituteSelected.replacement, '\%(&\|\\[0-9rnbt]\)', function('PatternsOnText#Selected#ReplaceSpecial'))
	endif
    else
	return submatch(0)
    endif
endfunction
function! PatternsOnText#Selected#ReplaceSpecial( expr, match, replacement )
    if a:replacement ==# '\n'
	return "\n"
    elseif a:replacement ==# '\r'
	return "\r"
    elseif a:replacement ==# '\t'
	return "\t"
    elseif a:replacement ==# '\b'
	return "\<BS>"
    elseif a:replacement =~# '^' . a:expr . '$'
	return submatch(a:replacement ==# '&' ? 0 : a:replacement[-1:-1])
    endif
    return ingo#escape#UnescapeExpr(a:replacement, '\%(\\\|' . a:expr . '\)')
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
function! PatternsOnText#Selected#Substitute( range, arguments, ... )
    call ingo#err#Clear()
    let s:SubstituteSelected = {'count': 0, 'lastLnum': 0}
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
	execute printf('%s%s %s%s%s\=PatternsOnText#Selected#CountedReplace()%s%s',
	\   a:range, (a:0 ? a:1 : 'substitute'),
	\   l:separator, l:pattern, l:separator, l:separator, l:substituteFlags
	\)

	" :substitute has visited all further matches, but the last replacement
	" may have happened before that. Position the cursor on the last
	" actually selected match.
	execute s:SubstituteSelected.lastLnum . 'normal! ^'
	return 1
    catch /^Vim\%((\a\+)\)\=:E/
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
