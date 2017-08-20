" Test renumbering of other pattern.

edit numbers.txt

Renumber /\<priority=\zs\d\+/
13Renumber 10/\<\d\d/g
20,21Renumber /\d\+\zes/g
24Renumber /\<and\>\|\<for\>/g

call vimtest#SaveOut()
call vimtest#Quit()
