" Test reuse of pattern, replacement, and flags when repeating replacement.

edit text.txt
1SubstituteExcept/\<...\>/{redacted}/
3SubstituteExcept

call vimtest#SaveOut()
call vimtest#Quit()
