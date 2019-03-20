" Test using the update predicate to do the substitution or not.

call vimtest#StartTap()
call vimtap#Plan(2)

edit text.txt
1SubstituteTransactional /\<...\>/<&>/gu/1/
call vimtap#err#Errors('Substitution aborted by update predicate', '2SubstituteTransactional /\<...\>/<&>/gu/0/', 'false value aborts substitution')
3SubstituteTransactional /\<...\>/\=toupper(v:val.matchText)/gu/v:val.matchNum >= 2/
call vimtap#err#Errors('Substitution aborted by update predicate', '3SubstituteTransactional /\<...\>/<&>/gu/v:val.matchNum >= 20/', 'false expression aborts substitution')

call vimtest#SaveOut()
call vimtest#Quit()
