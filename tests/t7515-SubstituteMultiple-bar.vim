" Test command invocation with a pair that contains a bar.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(1)
try
    %SubstituteMultiple /foo/F|O/ g
    call vimtap#Pass('bar is parsed as belonging inside the pair')
catch
    call vimtap#Fail('bar inside pair should not end command')
    call vimtap#Diag(v:exception)
endtry

call vimtest#Quit()
