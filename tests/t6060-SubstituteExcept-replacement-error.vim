" Test syntax error in special replacement.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
try
    1SubstituteExcept/\<...\>/\=string((((submatch(1)/
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown("E110: Missing ')'", 'error shown')
endtry

call vimtest#SaveOut()
call vimtest#Quit()
