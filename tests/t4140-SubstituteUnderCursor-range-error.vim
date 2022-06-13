" Test error when range is given for search under cursor.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#ErrorsLike('^E481: No range allowed:', '%SubstituteUnderCursor//REPLACEMENT/', 'No range allowed error shown')

call vimtest#Quit()
