" Test using the update predicate to rotate matches or not.

edit enumeration.txt
call vimtest#StartTap()
call vimtap#Plan(1)

1,4SubstituteRotate /\[\w\+\]/1/gu/v:val.matchNum >= 10/
call vimtap#err#Errors('Substitution aborted by update predicate', '7,8SubstituteRotate /\[\w\+\]/1/gu/v:val.matchNum >= 10/', 'false expression aborts substitution')

call vimtest#SaveOut()
call vimtest#Quit()
