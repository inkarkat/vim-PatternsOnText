" Test using the update predicate to do the substitution or not.

call vimtest#StartTap()
call vimtap#Plan(3)

edit text.txt
1SubstituteTransactionalExprEach /['\<...\>', '\[1\]']/"<&>"/gu/1/
call vimtap#err#Errors('E486: Pattern not found: \[1\]', '2SubstituteTransactionalExprEach /[''\<...\>'', ''\[1\]'']/"<&>"/gu/0/', 'no match for one pattern aborts substitution')
call vimtap#err#Errors('Substitution aborted by update predicate', '2SubstituteTransactionalExprEach /[''\<...\>'', ''!'']/"<&>"/gu/0/', 'false value aborts substitution')
3SubstituteTransactionalExprEach /['\<...\>', '!']/"\\=toupper(v:val.matchText)"/gu/v:val.matchNum >= 2/
call vimtap#err#Errors('Substitution aborted by update predicate', '3SubstituteTransactionalExprEach /[''\<...\>'', ''!'']/"<&>"/gu/v:val.matchNum >= 20/', 'false expression aborts substitution')

call vimtest#SaveOut()
call vimtest#Quit()
