" Test error when the pattern doesn't match.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#ErrorsLike('^E486: .*: \\(doesNotExist\\)', '%SubstituteTransactionalExpr /"doesNotExist"/"XXX"/', 'Pattern not found error shown')

call vimtest#SaveOut()
call vimtest#Quit()
