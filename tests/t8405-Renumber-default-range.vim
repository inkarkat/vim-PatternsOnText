" Test renumbering of entire buffer.

edit numbers.txt

3   " Move away from the first line.
Renumber g

call vimtest#SaveOut()
call vimtest#Quit()
