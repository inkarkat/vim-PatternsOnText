" PatternsOnText.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2011-2019 Ingo Karkat
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

"- configuration ---------------------------------------------------------------

if ! exists('g:PatternsOnText_PutTranslationsTemplateExpr')
    let g:PatternsOnText_PutTranslationsTemplateExpr = 'v:val.replacement . ": " . v:val.match . "\n"'
endif
if ! exists('g:PatternsOnText_YankTranslationsTemplateExpr')
    let g:PatternsOnText_YankTranslationsTemplateExpr = '":''[,'']substitute/" . ingo#regexp#EscapeLiteralText(v:val.replacement, "/") . "/" . escape(v:val.match, "/\\' . (&magic ? '&~' : '') . '") . "/g\n"'
endif


"- commands --------------------------------------------------------------------

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

command! -range -nargs=? SubstituteInSearch
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#InSearch#Substitute(0, <line1>, <line2>, <q-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=? SubstituteNotInSearch
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#InSearch#Substitute(1, <line1>, <line2>, <q-args>) | echoerr ingo#err#Get() | endif

command! -range -nargs=? -complete=expression SubstituteIf
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#If#Substitute(0, '<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=? -complete=expression SubstituteUnless
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#If#Substitute(1, '<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=? -complete=command    SubstituteExecute
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Execute#Substitute('<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif

command! -bang -range -nargs=? -complete=expression SubstituteTranslate
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Translate#Substitute('<line1>,<line2>', <bang>0, <q-args>) | echoerr ingo#err#Get() | endif
command! -range=-1 -nargs=? PutTranslations
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Translate#Put((<line2> == 1 ? <line1> : <line2>), <q-args>) | echoerr ingo#err#Get() | endif
command! -nargs=* YankTranslations
\   if ! PatternsOnText#Translate#Yank(<q-args>) | echoerr ingo#err#Get() | endif

command! -range -nargs=? SubstituteChoices
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Choices#Substitute('<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=* SubstituteMultiple
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Pairs#SubstituteMultiple('<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=* SubstituteWildcard
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Pairs#SubstituteWildcard('<line1>,<line2>', <f-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=* SubstituteMultipleExpr
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#PairsExpr#SubstituteMultipleExpr('<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=* SubstituteTransactional
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Transactional#Substitute('<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
command! -range -nargs=* SubstituteTransactionalExpr
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Transactional#Expr#Substitute('<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif

command! -bang -range=% -nargs=? PrintDuplicateLinesOf
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>,
\       '', 0,
\       PatternsOnText#DuplicateLines#PatternOrCurrentLine(<q-args>), <bang>0,
\       function('PatternsOnText#DuplicateLines#FilterDuplicateLines'),
\       function('PatternsOnText#DuplicateLines#PrintLines')
\       ) |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=1 PrintUniqueLinesOf
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>,
\       '', 0,
\       <q-args>, <bang>0,
\       function('PatternsOnText#DuplicateLines#FilterUniqueLines'),
\       function('PatternsOnText#DuplicateLines#PrintLines')
\       ) |
\       echoerr 'No unique lines' |
\   endif
command! -bang -range=% -nargs=? DeleteDuplicateLinesOf
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>,
\       '', 0,
\       PatternsOnText#DuplicateLines#PatternOrCurrentLine(<q-args>), <bang>0,
\       function('PatternsOnText#DuplicateLines#FilterDuplicateLines'),
\       function('PatternsOnText#DuplicateLines#DeleteSubsequentLines')
\   ) |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=? DeleteUniqueLinesOf
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>,
\       '', 0,
\       <q-args>, <bang>0,
\       function('PatternsOnText#DuplicateLines#FilterUniqueLines'),
\       function('PatternsOnText#DuplicateLines#DeleteAllLines')
\   ) |
\       echoerr 'No unique lines' |
\   endif
command! -bang -range=% -nargs=? PrintDuplicateLinesIgnoring
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>,
\       <q-args>, <bang>0,
\       '', 0,
\       function('PatternsOnText#DuplicateLines#FilterDuplicateLines'),
\       function('PatternsOnText#DuplicateLines#PrintLines')
\       ) |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=? PrintUniqueLinesIgnoring
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>,
\       <q-args>, <bang>0,
\       '', 0,
\       function('PatternsOnText#DuplicateLines#FilterUniqueLines'),
\       function('PatternsOnText#DuplicateLines#PrintLines')
\       ) |
\       echoerr 'No unique lines' |
\   endif
command! -bang -range=% -nargs=? DeleteDuplicateLinesIgnoring
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>,
\       <q-args>, <bang>0,
\       '', 0,
\       function('PatternsOnText#DuplicateLines#FilterDuplicateLines'),
\       function('PatternsOnText#DuplicateLines#DeleteSubsequentLines')
\       ) |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=? DeleteUniqueLinesIgnoring
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>,
\       <q-args>, <bang>0,
\       '', 0,
\       function('PatternsOnText#DuplicateLines#FilterUniqueLines'),
\       function('PatternsOnText#DuplicateLines#DeleteAllLines')
\       ) |
\       echoerr 'No unique lines' |
\   endif
command! -bang -range=% -nargs=? DeleteAllDuplicateLinesIgnoring
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>,
\       <q-args>, <bang>0,
\       '', 0,
\       function('PatternsOnText#DuplicateLines#FilterDuplicateLines'),
\       function('PatternsOnText#DuplicateLines#DeleteAllLines')
\       ) |
\       echoerr 'No duplicate lines' |
\   endif

command! -bang -range -nargs=? PrintDuplicates
\   if ! PatternsOnText#Duplicates#Process(<line1>, <line2>, <q-args>,
\       function('PatternsOnText#Duplicates#FilterDuplicates'),
\       '',
\       function('PatternsOnText#Duplicates#PrintMatches')
\       ) |
\       echoerr 'No duplicates' |
\   endif
command! -bang -range -nargs=? PrintUniques
\   if ! PatternsOnText#Duplicates#Process(<line1>, <line2>, <q-args>,
\       function('PatternsOnText#Uniques#FilterUnique'),
\       '',
\       function('PatternsOnText#Duplicates#PrintMatches')
\       ) |
\       echoerr 'No unique matches' |
\   endif
command! -bang -range -nargs=? DeleteDuplicates
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Duplicates#Process(<line1>, <line2>, <q-args>,
\       function('PatternsOnText#Duplicates#FilterDuplicates'),
\       function('PatternsOnText#Duplicates#DeleteMatches'),
\       function('PatternsOnText#Duplicates#ReportDeletedMatches')
\       ) |
\       echoerr 'No duplicates' |
\   endif
command! -bang -range -nargs=? DeleteAllDuplicates
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Duplicates#Process(<line1>, <line2>, <q-args>,
\       function('PatternsOnText#Uniques#FilterNonUnique'),
\       '',
\       function('PatternsOnText#Uniques#DeleteNonUnique')
\       ) |
\       echoerr 'No duplicates' |
\   endif
command! -bang -range -nargs=? DeleteUniques
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Duplicates#Process(<line1>, <line2>, <q-args>,
\       function('PatternsOnText#Uniques#FilterUnique'),
\       '',
\       function('PatternsOnText#Uniques#DeleteUnique')
\       ) |
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
