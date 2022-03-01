" Test error when there's no previous pattern for an empty search under cursor.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
let @/ = ''
call vimtap#err#Errors('No previous pattern', 'SubstituteUnderCursor//REPLACEMENT/', 'No previous pattern error shown')

call vimtest#Quit()
