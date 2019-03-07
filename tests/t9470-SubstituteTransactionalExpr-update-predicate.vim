" Test using the update predicate to do the substitution or not.

call vimtest#StartTap()
call vimtap#Plan(2)

edit text.txt
1SubstituteTransactionalExpr /['\<...\>', '\[1\]']/"<&>"/gu/1/
call vimtap#err#Throws('Substitution aborted by update predicate', '2SubstituteTransactional /[''\<...\>'', ''\[1\]'']/"<&>"/gu/0/', 'false value aborts substitution')
3SubstituteTransactionalExpr /['\<...\>', '\[1\]']/"\\=toupper(v:val.matchText)"/gu/v:val.matchNum >= 2/
call vimtap#err#Throws('Substitution aborted by update predicate', '3SubstituteTransactionalExpr /[''\<...\>'', ''\[1\]'']/"<&>"/gu/v:val.matchNum >= 20/', 'false expression aborts substitution')

call vimtest#SaveOut()
call vimtest#Quit()
