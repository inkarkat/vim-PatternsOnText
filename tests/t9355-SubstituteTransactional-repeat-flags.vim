" Test reuse of patterns and replacements when repeating with new flags.

call vimtest#StartTap()
call vimtap#Plan(4)

edit text.txt
call vimtap#err#Throws('Substitution aborted by update predicate', '2SubstituteTransactional /\<...\>/XXX/t/let v:val.n += len(substitute(submatch(0), "[^aeiou]", "", "g"))/u/v:val.n > 7/', 'false value aborts substitution')
call vimtap#err#Throws('Substitution aborted by update predicate', '1SubstituteTransactional', 'repeat without global flag still fails')
1SubstituteTransactional g
call vimtap#err#Throws('Substitution aborted by update predicate', '3SubstituteTransactional g', 'repeat substitution in line 3 with global flag still fails')
call vimtap#err#Throws('Substitution aborted by update predicate', '3SubstituteTransactional gu/v:val.n > 5/', 'repeat substitution with lower limit but omitting the test expression fails')
3SubstituteTransactional t/let v:val.n += len(substitute(submatch(0), "[^aeiou]", "", "g"))/u/v:val.n > 5/

call vimtest#SaveOut()
call vimtest#Quit()
