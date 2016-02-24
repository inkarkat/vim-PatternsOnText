" Test deleting non-matches in a single line.

edit text.txt
1
DeleteExcept /\<...\>/

call vimtest#SaveOut()
call vimtest#Quit()
