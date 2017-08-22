" Test renumbering with different format.

edit numbers.txt

2Renumber 9//%5d/g
4Renumber //0x%04X/g
6,9Renumber 75//%-4d/25
25Renumber -1//%G/g *100

call vimtest#SaveOut()
call vimtest#Quit()
