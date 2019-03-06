" Test replacing matches using the match position.

edit text.txt
%SubstituteTransactional /\<...\>/\='<' . col('.') . expand('<cWORD>') . '>'/g

call vimtest#SaveOut()
call vimtest#Quit()
