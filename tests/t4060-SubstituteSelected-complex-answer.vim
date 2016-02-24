" Test replacing with a complex answer in the buffer.

edit text.txt
%SubstituteSelected/\<...\>/XXX/g 2,yny,8-9,ny

call vimtest#SaveOut()
call vimtest#Quit()
