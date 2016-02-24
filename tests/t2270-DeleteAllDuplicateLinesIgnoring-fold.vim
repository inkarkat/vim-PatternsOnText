" Test deleting all duplicate lines in the folded buffer.
" Tests that only the duplicate lines itself are deleted, not the entire folds
" containing them.

edit duplicateLines.txt
4,5fold
6,7fold
8,9fold
2
DeleteAllDuplicateLinesIgnoring

call vimtest#SaveOut()
call vimtest#Quit()
