" Test translating matches in the buffer, with not enough items.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#err#Errors('Incomplete substitution: Need 4 more items', '%SubstituteTranslate /\<...\>/BAR/BAZ/QUX/QUY/g', 'error shown')

call vimtest#SaveOut()
call vimtest#Quit()
