" PatternsOnText.vim: Advanced commands to apply regular expressions.
"
" DEPENDENCIES:
"   - PatternsOnText.vim autoload script
"   - ingocollections.vim autoload script
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	21-Jan-2013	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_PatternsOnText') || (v:version < 700)
    finish
endif
let g:loaded_PatternsOnText = 1
let s:save_cpo = &cpo
set cpo&vim

command! -bar -range -nargs=? SubstituteExcept call PatternsOnText#SubstituteExcept('<line1>,<line2>', <q-args>)
command! -bar -range -nargs=? DeleteExcept call PatternsOnText#DeleteExcept('<line1>,<line2>', <q-args>)

command! -bar -range -nargs=1 SubstituteSelected call PatternsOnText#SubstituteSelected('<line1>,<line2>', <q-args>)

command! -range -nargs=? SubstituteInSearch call PatternsOnText#SubstituteInSearch(<line1>, <line2>, <q-args>)

command! -bang -range=% -nargs=? PrintDuplicateLinesOf
\   if ! PatternsOnText#ProcessDuplicateLines(<line1>, <line2>, '', PatternsOnText#PatternOrCurrentLine(<q-args>), function('PatternsOnText#PrintLines'))  && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=? DeleteDuplicateLinesOf
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#ProcessDuplicateLines(<line1>, <line2>, '', PatternsOnText#PatternOrCurrentLine(<q-args>), function('PatternsOnText#DeleteLines')) && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=? PrintDuplicateLinesIgnoring
\   if ! PatternsOnText#ProcessDuplicateLines(<line1>, <line2>, <q-args>, '', function('PatternsOnText#PrintLines')) && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif
command! -bang -range=% -nargs=? DeleteDuplicateLinesIgnoring
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#ProcessDuplicateLines(<line1>, <line2>, <q-args>, '', function('PatternsOnText#DeleteLines')) && <bang>1 |
\       echoerr 'No duplicate lines' |
\   endif

command! -bar -bang -range -nargs=? PrintDuplicates
\   if ! PatternsOnText#ProcessDuplicates(<line1>, <line2>, <q-args>, '', function('PatternsOnText#PrintMatches')) && <bang>1 |
\       echoerr 'No duplicates' |
\   endif
command! -bar -bang -range -nargs=? DeleteDuplicates
\   call setline(<line1>, getline(<line1>)) |
\   if ! PatternsOnText#ProcessDuplicates(<line1>, <line2>, <q-args>, function('PatternsOnText#DeleteMatches'), '') && <bang>1 |
\       echoerr 'No duplicates' |
\   endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
