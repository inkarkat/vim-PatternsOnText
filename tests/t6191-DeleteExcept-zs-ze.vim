" Test error when using set start or end match inside the pattern.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(2)
try
    1DeleteExcept/\<.\zs..\>/
    call vimtap#Fail('expected error on using zs atom')
catch
    call vimtap#err#Thrown('The pattern cannot use the set start / end match patterns \zs / \ze: /\<.\zs..\>/', 'error shown')
endtry
try
    2DeleteExcept/\<..\ze.\>/
    call vimtap#Fail('expected error on using ze atom')
catch
    call vimtap#err#Thrown('The pattern cannot use the set start / end match patterns \zs / \ze: /\<..\ze.\>/', 'error shown')
endtry

call vimtest#Quit()
