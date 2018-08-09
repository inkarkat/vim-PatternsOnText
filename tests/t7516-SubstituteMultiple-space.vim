" Test command invocation with a pair that contains a space.

edit text.txt
%SubstituteMultiple /foo/F \// # and # or # g

call vimtest#SaveOut()
call vimtest#Quit()
