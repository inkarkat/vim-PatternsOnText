" Test references in replacement.

edit text.txt
1SubstituteExcept/\<\(.\).\(.\)\>/{\1\2}/
2SubstituteExcept/\<\(\k*\)a\k*\>/{\1}/
3SubstituteExcept/\s*foo\s*/{&}/i

call vimtest#SaveOut()
call vimtest#Quit()
