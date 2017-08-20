" Test renumbering with different format.

edit numbers.txt

2Renumber 9//%5d/g
4Renumber //0x%04X/g
6,9Renumber 75//%-4d/25
24Renumber -1000//%G/g *1000

call vimtest#SaveOut()
call vimtest#Quit()
