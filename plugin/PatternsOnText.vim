" PatternsOnText.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - PatternsOnText.vim autoload script
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.003	04-Mar-2013	ENH: Also print :substitute-like summary on
"				deletion via
"				PatternsOnText#Duplicates#ReportDeletedMatches().
"	002	22-Jan-2013	Separate each functionality part into a separate
"				autoload module.
"	001	21-Jan-2013	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_PatternsOnText') || (v:version < 700)
    finish
endif
let g:loaded_PatternsOnText = 1
let s:save_cpo = &cpo
set cpo&vim

command! -bar -range -nargs=? SubstituteExcept call PatternsOnText#Except#Substitute('<line1>,<line2>', <q-args>)
command! -bar -range -nargs=? DeleteExcept call PatternsOnText#Except#Delete('<line1>,<line2>', <q-args>)

command! -bar -range -nargs=1 SubstituteSelected call PatternsOnText#Selected#Substitute('<line1>,<line2>', <q-args>)

command! -range -nargs=? SubstituteInSearch call PatternsOnText#InSearch#Substitute(<line1>, <line2>, <q-args>)

command! -bang -range=% -nargs=? PrintDuplicateLinesOf
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, '', PatternsOnText#DuplicateLines#PatternOrCurrentLine(<q-args>), function('PatternsOnText#DuplicateLines#PrintLines'))  && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=? DeleteDuplicateLinesOf
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, '', PatternsOnText#DuplicateLines#PatternOrCurrentLine(<q-args>), function('PatternsOnText#DuplicateLines#DeleteLines')) && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=? PrintDuplicateLinesIgnoring
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, <q-args>, '', function('PatternsOnText#DuplicateLines#PrintLines')) && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=? DeleteDuplicateLinesIgnoring
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#DuplicateLines#Process(<line1>, <line2>, <q-args>, '', function('PatternsOnText#DuplicateLines#DeleteLines')) && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif

command! -bar -bang -range -nargs=? PrintDuplicates
\   if ! PatternsOnText#Duplicates#Process(<line1>, <line2>, <q-args>, '', function('PatternsOnText#Duplicates#PrintMatches')) && <bang>1 |
\       echoerr 'No duplicates' |
\   endif
command! -bar -bang -range -nargs=? DeleteDuplicates
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#Duplicates#Process(<line1>, <line2>, <q-args>, function('PatternsOnText#Duplicates#DeleteMatches'), function('PatternsOnText#Duplicates#ReportDeletedMatches')) && <bang>1 |
\       echoerr 'No duplicates' |
\   endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
