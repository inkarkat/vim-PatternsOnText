" Test simple global / first renumbering.

edit numbers.txt

4Renumber g
19,22Renumber
25
.Renumber g

call vimtest#SaveOut()
call vimtest#Quit()
