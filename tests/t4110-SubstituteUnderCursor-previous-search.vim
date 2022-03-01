" Test replacing previous search pattern only under the cursor.

edit text.txt

let @/ = '\<foo\>'
3normal! 3w
SubstituteUnderCursor//FIRST/

1normal! e
SubstituteUnderCursor//~/

call vimtest#SaveOut()
call vimtest#Quit()
