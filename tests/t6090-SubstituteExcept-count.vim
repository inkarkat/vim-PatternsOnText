" Test replacing non-matches with count.

edit text.txt
1
SubstituteExcept/\<.o.\>/{redacted}/i 2

call vimtest#SaveOut()
call vimtest#Quit()
