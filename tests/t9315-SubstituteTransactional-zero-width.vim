" Test replacing zero-width matches.

edit text.txt
%SubstituteTransactional /!\zs/?/g

call vimtest#SaveOut()
call vimtest#Quit()
