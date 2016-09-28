" Test reuse of pattern, flags, and expression when repeating substitution.

edit text.txt
1SubstituteExecute /foo/g return '[' . toupper(submatch(0)) . ']'
3SubstituteExecute

call vimtest#SaveOut()
call vimtest#Quit()
