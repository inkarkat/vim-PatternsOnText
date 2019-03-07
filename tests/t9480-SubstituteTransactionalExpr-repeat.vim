" Test capturing additional information in the test expression and then using that in the update predicate.

call vimtest#StartTap()
call vimtap#Plan(2)

edit text.txt
call vimtap#err#Throws('Substitution aborted by update predicate', '2SubstituteTransactionalExpr /"\\<...\\>"/"XXX"/gt/let v:val.n += len(substitute(submatch(0), "[^aeiou]", "", "g"))/u/v:val.n > 7/', 'false value aborts substitution')
1SubstituteTransactionalExpr
call vimtap#err#Throws('Substitution aborted by update predicate', '3SubstituteTransactionalExpr', 'repeat substitution in line 3 is aborted')

call vimtest#SaveOut()
call vimtest#Quit()
