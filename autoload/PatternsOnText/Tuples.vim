" PatternsOnText/Tuples.vim: Advanced commands to apply tuples.
"
" DEPENDENCIES:
"   - ingo/err.vim autoload script
"   - ingo/subst/tuples.vim autoload script
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.20.001	16-Jan-2014	file creation

function! PatternsOnText#Tuples#Substitute( range, ... )
    let l:tuples = copy(a:000)
    let l:count = ''
    let l:flags = ''
    if l:tuples[-1] =~# '^\d\+$'
	let l:count = remove(l:tuples, -1)
    endif
    if l:tuples[-1] =~# '^&\?[cegiInp#lr]*\d*$'
	let l:flags = remove(l:tuples, -1)
    endif

    try
	let l:pairs = ingo#subst#tuples#GetPairs(l:tuples)
	" Surround each individual match with a capturing group, so that we can
	" determine which branch matched (and use the corresponding
	" replacement).
	let l:pattern = join(map(copy(l:pairs), '"\\(" . escape(v:val[0], "/") . "\\)"'), '\|')
	let s:replacements = map(copy(l:pairs), 'v:val[1]')

	execute printf('%ssubstitute/%s/\=s:Replacement()/%s %s',
	\   a:range, l:pattern, l:flags, l:count
	\)
	return 1
    catch /^Substitute:/
	call ingo#err#SetCustomException('Substitute')
	return 0
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#err#SetVimException()
	return 0
    finally
	let s:replacements = []
    endtry
endfunction
function! s:Replacement()
    for l:i in range(len(s:replacements))
	if ! empty(submatch(l:i + 1))
	    return s:replacements[l:i]
	endif
    endfor

    " Should never happen; one branch always matches, and branches shouldn't be
    " empty.
    return ''
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
