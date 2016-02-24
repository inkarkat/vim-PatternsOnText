" Test error when using set start or end match inside the pattern.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(2)
call vimtap#err#Errors('The pattern cannot use the set start / end match patterns \zs / \ze: /\<.\zs..\>/', '1DeleteExcept/\<.\zs..\>/', 'error shown')
call vimtap#err#Errors('The pattern cannot use the set start / end match patterns \zs / \ze: /\<..\ze.\>/', '2DeleteExcept/\<..\ze.\>/', 'error shown')

call vimtest#Quit()
