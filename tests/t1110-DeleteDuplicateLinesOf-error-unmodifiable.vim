" Test error message when buffer is not modifiable.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
setlocal nomodifiable
2
call vimtap#err#ErrorsLike('^E21:', 'DeleteDuplicateLinesOf', 'error shown')

call vimtest#Quit()
