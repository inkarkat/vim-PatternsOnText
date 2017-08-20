" Test renumbering with floats.

edit numbers.txt

2Renumber g 0.1
4Renumber 0.5 g 0.5
6,9Renumber 2.0//%2.2f/0.333333333
18,21Renumber 1.0e6 g 1.5e5
28Renumber 0.0 g -0.01

call vimtest#SaveOut()
call vimtest#Quit()
