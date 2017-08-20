" Test renumbering with multiplicator offset.

edit numbers.txt

2Renumber 2 g *2
18,19Renumber 0.2 g *16
20,23Renumber 5.36870912e7 g *6.25e-2
24Renumber 10/-1\|\<and\>\|\<for\>/g *10

call vimtest#SaveOut()
call vimtest#Quit()
