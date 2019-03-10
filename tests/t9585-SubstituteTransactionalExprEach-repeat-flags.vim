" Test reuse of patterns and replacements when repeating with new flags.

call vimtest#StartTap()
call vimtap#Plan(4)

edit text.txt
call vimtap#err#Throws('Substitution aborted by update predicate', '2SubstituteTransactionalExprEach /"\\<...\\>"/"XXX"/t/let v:val.n += len(substitute(submatch(0), "[^aeiou]", "", "g"))/u/v:val.n > 7/', 'false value aborts substitution')
call vimtap#err#Throws('Substitution aborted by update predicate', '1SubstituteTransactionalExprEach', 'repeat without global flag still fails')
1SubstituteTransactionalExprEach g
call vimtap#err#Throws('Substitution aborted by update predicate', '3SubstituteTransactionalExprEach g', 'repeat substitution in line 3 with global flag still fails')
call vimtap#err#Throws('Substitution aborted by update predicate', '3SubstituteTransactionalExprEach gu/v:val.n > 5/', 'repeat substitution with lower limit but omitting the test expression fails')
3SubstituteTransactionalExprEach t/let v:val.n += len(substitute(submatch(0), "[^aeiou]", "", "g"))/u/v:val.n > 5/

call vimtest#SaveOut()
call vimtest#Quit()
