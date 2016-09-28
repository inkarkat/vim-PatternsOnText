" Test replacing with expression in a line.

edit text.txt
1
SubstituteExecute /foo/g return '[' . toupper(submatch(0)) . ']'

call vimtest#SaveOut()
call vimtest#Quit()
