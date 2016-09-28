" Test reuse of pattern, flags, but new expression when repeating substitution.

edit text.txt
1SubstituteExecute /foo/g return '[' . toupper(submatch(0)) . ']'
3SubstituteExecute return '{' . toupper(submatch(0)) . '}'

call vimtest#SaveOut()
call vimtest#Quit()
