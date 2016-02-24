" Test replacing non-matches in a single line.

edit text.txt
1
SubstituteExcept/\<...\>/{redacted}/

call vimtest#SaveOut()
call vimtest#Quit()
