" Test priming first then renumbering.

edit numbers.txt

0Renumber 1.1//(%G)/g 1.1
13Renumber &
12Renumber &

0Renumber 10 10
global/^@Test/execute '.Renumber &'
6,9Renumber &

0Renumber 2/-\?\(0x\)\?\d\+/<%s>/ge *2
25Renumber &
26Renumber &
29Renumber &

call vimtest#SaveOut()
call vimtest#Quit()
