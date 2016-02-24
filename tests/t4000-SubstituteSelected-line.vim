" Test replacing the second of four instances in a single line.

edit text.txt
1
SubstituteSelected/foo/XXX/g nynn

call vimtest#SaveOut()
call vimtest#Quit()
