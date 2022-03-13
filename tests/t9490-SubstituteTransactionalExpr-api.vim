" Test using the API.

call vimtest#StartTap()
call vimtap#Plan(3)

edit text.txt
call vimtap#Ok(! PatternsOnText#Transactional#Expr#TransactionalSubstitute('', '1,3', ['\<....\>', '\[1\]'], ['XXXX', 'DECLINED'], 'g', 'let v:val.n += len(substitute(submatch(0), "[^aeiou]", "", "g"))', 'v:val.n > 10'), 'update predicate aborts substitution')
call vimtap#Is(ingo#err#Get(), 'Substitution aborted by update predicate', 'error message')
call vimtap#Ok(  PatternsOnText#Transactional#Expr#TransactionalSubstitute('', '1,3', ['\<...\>', '\<and\>'],  ['YYY', 'or'],  'g', 'let v:val.n += len(substitute(submatch(0), "[^aeiou]", "", "g"))', 'v:val.n > 10'), 'update predicate greenlights substitution')

call vimtest#SaveOut()
call vimtest#Quit()
