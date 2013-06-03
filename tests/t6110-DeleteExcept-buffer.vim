" Test deleting non-matches in the buffer.

edit text.txt
%DeleteExcept/\<...\>/

call vimtest#SaveOut()
call vimtest#Quit()
