" Test using forbidden capture groups.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#Errors('Capture groups not allowed in pattern: f\(o\+\)', '%SubstituteMultiple /f\(o\+\)/FOO/ /bar/XXX/ g', 'error shown')

call vimtest#Quit()
