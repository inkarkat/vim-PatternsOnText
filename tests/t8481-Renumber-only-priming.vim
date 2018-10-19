" Test priming itself does not change the buffer.

edit numbers.txt

0Renumber 10 10

call vimtest#SaveOut()
call vimtest#Quit()
