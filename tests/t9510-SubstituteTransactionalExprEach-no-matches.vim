" Test error when the pattern doesn't match.

call vimtest#StartTap()
call vimtap#Plan(2)

edit text.txt
call vimtap#err#ErrorsLike('^E486: .*: doesNotExist', '%SubstituteTransactionalExprEach /"doesNotExist"/"XXX"/', 'Pattern not found error shown')
call vimtap#err#ErrorsLike('^E486: .*: FOObar', "%SubstituteTransactionalExprEach /['foobar', 'foo', 'FOObar']/['hihohu', 'FOO', 'XXXXXX']/g", 'Pattern not found error shown for FOObar')

call vimtest#SaveOut()
call vimtest#Quit()
