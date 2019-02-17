" Test putting no translations yet done.

edit text.txt

call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#Throws('No translations yet', '$PutTranslations', 'no translations error')

call vimtest#SaveOut()
call vimtest#Quit()
