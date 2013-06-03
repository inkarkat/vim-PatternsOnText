" Test replacing every second instance in the buffer.

edit text.txt
%SubstituteSelected/foo/XXX/g ny

call vimtest#SaveOut()
call vimtest#Quit()
