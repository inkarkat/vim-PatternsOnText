" Test using forbidden capture groups.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
try
    %SubstituteMultiple /f\(o\+\)/FOO/ /bar/XXX/ g
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Capture groups not allowed in pattern: f\(o\+\)', 'error shown')
endtry

call vimtest#Quit()
