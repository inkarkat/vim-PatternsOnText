" Test replacing non-matches without and with other flags.

edit text.txt
3SubstituteExcept/foo/{redacted}/gi
set gdefault
1SubstituteExcept/\<...\>/{redacted}/g
2SubstituteExcept/\<\k*a\k*\>/{redacted}/g

call vimtest#SaveOut()
call vimtest#Quit()
