" Test deleting non-matches with other flags.

edit text.txt
3DeleteExcept/foo/i
set gdefault
1DeleteExcept/\<...\>/g

call vimtest#SaveOut()
call vimtest#Quit()
