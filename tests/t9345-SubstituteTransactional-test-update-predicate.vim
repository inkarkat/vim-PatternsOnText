" Test capturing additional information in the test expression and then using that in the update predicate.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#Errors('Substitution aborted by update predicate', '%SubstituteTransactional /\<....\>/XXXX/gt/let v:val.n += len(substitute(submatch(0), "[^aeiou]", "", "g"))/u/v:val.n > 10/', 'false value aborts substitution')
%SubstituteTransactional /\<...\>/YYY/gt/let v:val.n += len(substitute(submatch(0), "[^aeiou]", "", "g"))/u/v:val.n > 10/

call vimtest#SaveOut()
call vimtest#Quit()
