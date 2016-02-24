" Test that magic atoms can be used inside the passed pattern.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(2)
try
    1DeleteExcept/\v<...|my>/
    call vimtap#Pass('very magic atom is accepted')
catch
    call vimtap#Fail('very magic atom causes error')
    call vimtap#Diag(v:exception)
endtry
try
    2DeleteExcept/\V\<\.\.\.\|my\>/
    call vimtap#Pass('very nomagic atom is accepted')
catch
    call vimtap#Fail('very nomagic atom causes error')
    call vimtap#Diag(v:exception)
endtry

call vimtest#Quit()
