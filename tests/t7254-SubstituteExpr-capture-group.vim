" Test using forbidden capture groups in expr.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#Errors('Capture groups not allowed in pattern #2: f\(o\+\)', '%SubstituteExpr [["bar", "XXX"], [''f\(o\+\)'', "FOO"]] g', 'error shown')

call vimtest#Quit()
