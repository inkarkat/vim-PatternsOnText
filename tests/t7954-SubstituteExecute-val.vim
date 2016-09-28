" Test replacing with predicate that uses v:val.

edit text.txt
%SubstituteExecute /\<...\>/g return v:val.matchCount . submatch(0)

call vimtest#SaveOut()
call vimtest#Quit()
