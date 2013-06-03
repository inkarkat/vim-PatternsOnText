" Test replacing non-matches in the buffer.

edit text.txt
%SubstituteExcept/\<...\>/{redacted}/

call vimtest#SaveOut()
call vimtest#Quit()
