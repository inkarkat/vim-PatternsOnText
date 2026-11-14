" Test error when the expr doesn't match.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#ErrorsLike('^E486: .*: \\(doesNotExist\\)', '%SubstituteExpr ["doesNotExist", "XXX"]', 'Pattern not found error shown')

call vimtest#Quit()
