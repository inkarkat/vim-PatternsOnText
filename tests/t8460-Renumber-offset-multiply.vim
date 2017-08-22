" Test renumbering with multiplicator offset.

call vimtest#SkipAndQuitIf(! has('float'), 'Need support for +float')

edit numbers.txt

2Renumber 2 g *2
19,20Renumber 0.2 g *16
21,24Renumber 5.36870912e7 g *6.25e-2
25Renumber 10/-1\|\<and\>\|\<for\>/g *10

call vimtest#SaveOut()
call vimtest#Quit()
