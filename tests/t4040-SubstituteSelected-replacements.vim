" Test references in replacement.

edit text.txt
1SubstituteSelected/\<\(.\)\(.\)\2\>/{\2:\1\0}/g yn
3SubstituteSelected/foo/& and &/gi yny

call vimtest#SaveOut()
call vimtest#Quit()
