" Test using forbidden capture groups.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#Errors('Capture groups not allowed in pattern #2: f\(o\+\)', '%SubstituteMultipleExpr /["bar", ''f\(o\+\)'']/["XXX", "FOO"]/g', 'error shown')

call vimtest#Quit()
