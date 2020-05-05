" Test error when the pattern doesn't match.

call vimtest#StartTap()
call vimtap#Plan(1)

edit enumeration.txt
call vimtap#err#ErrorsLike('^E486: .*: doesNotExist', '%SubstituteRotate /doesNotExist/1/', 'Pattern not found error shown')

call vimtest#SaveOut()
call vimtest#Quit()
