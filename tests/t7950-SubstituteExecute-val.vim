" Test replacing with expression that uses v:val.

edit text.txt
%SubstituteExecute /foo/g return v:val.matchCount % 2 ? 'XXX' : 'YYY'

call vimtest#SaveOut()
call vimtest#Quit()
