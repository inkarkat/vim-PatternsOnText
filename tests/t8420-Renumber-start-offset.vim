" Test renumbering with different start and offset.

edit numbers.txt

4Renumber 5 g 10
18,21Renumber -3 -1
24Renumber -20g10

call vimtest#SaveOut()
call vimtest#Quit()
