" Test reuse of pattern, replacement, but new flags when repeating replacement.

edit text.txt
1SubstituteExcept/\<f..\>/{redacted}/
3SubstituteExcept i

call vimtest#SaveOut()
call vimtest#Quit()
