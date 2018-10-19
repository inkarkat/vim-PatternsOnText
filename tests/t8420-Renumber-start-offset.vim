" Test renumbering with different start and offset.

edit numbers.txt

4Renumber 5 g 10
19,22Renumber -3 -1
25Renumber -20g10

call vimtest#SaveOut()
call vimtest#Quit()
