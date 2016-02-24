" Test syntax error in special replacement.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#ErrorsLike("^E110: .* ')'", '1SubstituteExcept/\<...\>/\=string((((submatch(1)/', 'Missing ) error shown')

call vimtest#SaveOut()
call vimtest#Quit()
