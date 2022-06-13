" Test using the API.

call vimtest#StartTap()
call vimtap#Plan(3)

edit text.txt
call vimtap#Ok(! PatternsOnText#Transactional#TransactionalSubstitute('', '1,3', '\<....\>', 'XXXX', 'g', 'let v:val.n += len(substitute(submatch(0), "[^aeiou]", "", "g"))', 'v:val.n > 10'), 'update predicate aborts substitution')
call vimtap#Is(ingo#err#Get(), 'Substitution aborted by update predicate', 'error message')
call vimtap#Ok(  PatternsOnText#Transactional#TransactionalSubstitute('', '1,3', '\<...\>',  'YYY',  'g', 'let v:val.n += len(substitute(submatch(0), "[^aeiou]", "", "g"))', 'v:val.n > 10'), 'update predicate greenlights substitution')

call vimtest#SaveOut()
call vimtest#Quit()
