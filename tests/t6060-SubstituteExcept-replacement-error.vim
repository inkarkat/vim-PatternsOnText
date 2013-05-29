" Test syntax error in special replacement.

edit text.txt
1SubstituteExcept/\<...\>/\=string((((submatch(1)/

call vimtest#SaveOut()
call vimtest#Quit()
