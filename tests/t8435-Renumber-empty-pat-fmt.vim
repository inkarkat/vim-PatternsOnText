" Test renumbering with empty pattern and format.

edit numbers.txt

2Renumber ///g
4Renumber 10//g
19,22Renumber ///
25Renumber /\<and\>//g

call vimtest#SaveOut()
call vimtest#Quit()
