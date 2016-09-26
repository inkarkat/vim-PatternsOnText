" Test replacing with choices that reference the match in various ways.

let g:IngoLibrary_QueryChoices = [0, 1, 2, 3, 4, 0, 1, 2, 3, 4]
edit text.txt
1
%SubstituteChoices /\<\(\l\)\(\l\)\(\l\)\>/(&)/[&]/<\0\>/{\3\2\1}/\r\1\r\2\r\3\r/g

call vimtest#SaveOut()
call vimtest#Quit()
