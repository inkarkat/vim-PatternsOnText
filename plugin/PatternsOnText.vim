" PatternsOnText.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - PatternsOnText/*.vim autoload scripts
"   - ingo/err.vim autoload script
"
" Copyright: (C) 2011-2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_PatternsOnText') || (v:version < 700)
    finish
endif
let g:loaded_PatternsOnText = 1
let s:save_cpo = &cpo
set cpo&vim

command! -range -nargs=? SubstituteExcept
\   call setline(<line1>, getline(<line1>)) |
\   call PatternsOnText#Except#Substitute('<line1>,<line2>', <q-args>) | let @/ = histget('search', -1) | if ingo#err#IsSet() | echoerr ingo#err#Get() | endif
command! -range -nargs=? DeleteExcept
\   call setline(<line1>, getline(<line1>)) |
\   call PatternsOnText#Except#Delete('<line1>,<line2>', <q-args>) | let @/ = histget('search', -1) | if ingo#err#IsSet() | echoerr ingo#err#Get() | endif

command! -range -nargs=? SubstituteSelected
\   call setline(<line1>, getline(<line1>)) |
\   call PatternsOnText#Selected#Substitute('<line1>,<line2>', <q-args>) |
\   let @/ = histget('search', -1) |
\   if ingo#err#IsSet() | echoerr ingo#err#Get() | endif
command! -range -nargs=? SubstituteSubsequent
\   call setline(<line1>, getline(<line1>)) |
\   call PatternsOnText#Subsequent#Substitute('substitute', 'SubstituteSelected', <line1>, <line2>, <q-args>) |
\   let @/ = histget('search', -1) |
\   if ingo#err#IsSet() | echoerr ingo#err#Get() | endif

command! -range -nargs=? SubstituteInSearch    if ! PatternsOnText#InSearch#Substitute(0, <line1>, <line2>, <q-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=? SubstituteNotInSearch if ! PatternsOnText#InSearch#Substitute(1, <line1>, <line2>, <q-args>) | echoerr ingo#err#Get() | endif

command! -range -nargs=? -complete=expression SubstituteIf       if ! PatternsOnText#If#Substitute(0, '<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=? -complete=expression SubstituteUnless   if ! PatternsOnText#If#Substitute(1, '<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=? -complete=command    SubstituteExecute  if ! PatternsOnText#Execute#Substitute('<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=? SubstituteChoices  if ! PatternsOnText#Choices#Substitute('<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=* SubstituteMultiple if ! PatternsOnText#Pairs#SubstituteMultiple('<line1>,<line2>', <f-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=* SubstituteWildcard if ! PatternsOnText#Pairs#SubstituteWildcard('<line1>,<line2>', <f-args>) | echoerr ingo#err#Get() | endif

command! -bang -range=% -nargs=? PrintDuplicateLinesOf
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, '',
\       PatternsOnText#DuplicateLines#PatternOrCurrentLine(<q-args>),
\       function('PatternsOnText#DuplicateLines#FilterDuplicateLines'),
\       function('PatternsOnText#DuplicateLines#PrintLines')
\       )  && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=1 PrintUniqueLinesOf
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, '',
\       <q-args>,
\       function('PatternsOnText#DuplicateLines#FilterUniqueLines'),
\       function('PatternsOnText#DuplicateLines#PrintLines')
\       )  && <bang>1 |
\       echoerr 'No unique lines' |
\   endif
command! -bang -range=% -nargs=? DeleteDuplicateLinesOf
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, '',
\       PatternsOnText#DuplicateLines#PatternOrCurrentLine(<q-args>),
\       function('PatternsOnText#DuplicateLines#FilterDuplicateLines'),
\       function('PatternsOnText#DuplicateLines#DeleteSubsequentLines')
\   ) && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=? DeleteUniqueLinesOf
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, '',
\       <q-args>,
\       function('PatternsOnText#DuplicateLines#FilterUniqueLines'),
\       function('PatternsOnText#DuplicateLines#DeleteAllLines')
\   ) && <bang>1 |
\       echoerr 'No unique lines' |
\   endif
command! -bang -range=% -nargs=? PrintDuplicateLinesIgnoring
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, <q-args>, '',
\       function('PatternsOnText#DuplicateLines#FilterDuplicateLines'),
\       function('PatternsOnText#DuplicateLines#PrintLines')
\       ) && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=? PrintUniqueLinesIgnoring
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, <q-args>, '',
\       function('PatternsOnText#DuplicateLines#FilterUniqueLines'),
\       function('PatternsOnText#DuplicateLines#PrintLines')
\       ) && <bang>1 |
\       echoerr 'No unique lines' |
\   endif
command! -bang -range=% -nargs=? DeleteDuplicateLinesIgnoring
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, <q-args>, '',
\       function('PatternsOnText#DuplicateLines#FilterDuplicateLines'),
\       function('PatternsOnText#DuplicateLines#DeleteSubsequentLines')
\       ) && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=? DeleteUniqueLinesIgnoring
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, <q-args>, '',
\       function('PatternsOnText#DuplicateLines#FilterUniqueLines'),
\       function('PatternsOnText#DuplicateLines#DeleteAllLines')
\       ) && <bang>1 |
\       echoerr 'No unique lines' |
\   endif
command! -bang -range=% -nargs=? DeleteAllDuplicateLinesIgnoring
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, <q-args>, '',
\       function('PatternsOnText#DuplicateLines#FilterDuplicateLines'),
\       function('PatternsOnText#DuplicateLines#DeleteAllLines')
\       ) && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif

command! -bang -range -nargs=? PrintDuplicates
\   if ! PatternsOnText#Duplicates#Process(<line1>, <line2>, <q-args>,
\       function('PatternsOnText#Duplicates#FilterDuplicates'),
\       '',
\       function('PatternsOnText#Duplicates#PrintMatches')
\       ) && <bang>1 |
\       echoerr 'No duplicates' |
\   endif
command! -bang -range -nargs=? PrintUniques
\   if ! PatternsOnText#Duplicates#Process(<line1>, <line2>, <q-args>,
\       function('PatternsOnText#Uniques#FilterUnique'),
\       '',
\       function('PatternsOnText#Duplicates#PrintMatches')
\       ) && <bang>1 |
\       echoerr 'No unique matches' |
\   endif
command! -bang -range -nargs=? DeleteDuplicates
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Duplicates#Process(<line1>, <line2>, <q-args>,
\       function('PatternsOnText#Duplicates#FilterDuplicates'),
\       function('PatternsOnText#Duplicates#DeleteMatches'),
\       function('PatternsOnText#Duplicates#ReportDeletedMatches')
\       ) && <bang>1 |
\       echoerr 'No duplicates' |
\   endif
command! -bang -range -nargs=? DeleteAllDuplicates
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Duplicates#Process(<line1>, <line2>, <q-args>,
\       function('PatternsOnText#Uniques#FilterNonUnique'),
\       '',
\       function('PatternsOnText#Uniques#DeleteNonUnique')
\       ) && <bang>1 |
\       echoerr 'No duplicates' |
\   endif
command! -bang -range -nargs=? DeleteUniques
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Duplicates#Process(<line1>, <line2>, <q-args>,
\       function('PatternsOnText#Uniques#FilterUnique'),
\       '',
\       function('PatternsOnText#Uniques#DeleteUnique')
\       ) && <bang>1 |
\       echoerr 'No unique matches' |
\   endif

command! -bang -range=% -nargs=+ DeleteRanges
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Ranges#Command('delete', <line1>, <line2>, <bang>0, <q-args>) |
\       echoerr ingo#err#Get() |
\   endif
command! -bang -range=% -nargs=+ YankRanges
\   if ! PatternsOnText#Ranges#Command('yank', <line1>, <line2>, <bang>0, <q-args>) |
\       echoerr ingo#err#Get() |
\   endif
command! -bang -range=% -nargs=+ PrintRanges
\   if ! PatternsOnText#Ranges#Command('print', <line1>, <line2>, <bang>0, <q-args>) |
\       echoerr ingo#err#Get() |
\   endif
command! -bang -range=% -nargs=+ RangeDo
\   if ! PatternsOnText#Ranges#Command('do', <line1>, <line2>, <bang>0, <q-args>) |
\       echoerr ingo#err#Get() |
\   endif

command! -range=-1 -nargs=? Renumber
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Renumber#Renumber((<count> == 0), (<count> == -1 && <line2> == 1 ? '1,' . line('$') : '<line1>,<line2>'), <q-args>) |
\       echoerr ingo#err#Get() |
\   endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
