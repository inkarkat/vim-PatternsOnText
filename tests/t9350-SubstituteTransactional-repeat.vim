" Test reuse of patterns, replacements, flags, test expression and update predicate when repeating substitution.

call vimtest#StartTap()
call vimtap#Plan(2)

edit text.txt
call vimtap#err#Throws('Substitution aborted by update predicate', '2SubstituteTransactional /\<...\>/XXX/gt/let v:val.n += len(substitute(submatch(0), "[^aeiou]", "", "g"))/u/v:val.n > 7/', 'false value aborts substitution')
1SubstituteTransactional
call vimtap#err#Throws('Substitution aborted by update predicate', '3SubstituteTransactional', 'repeat substitution in line 3 is aborted')

call vimtest#SaveOut()
call vimtest#Quit()
