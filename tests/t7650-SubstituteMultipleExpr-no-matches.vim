" Test error when the pair doesn't match.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#ErrorsLike('^E486: .*: \\(doesNotExist\\)', '%SubstituteMultipleExpr /"doesNotExist"/"XXX"/', 'Pattern not found error shown')

call vimtest#Quit()
