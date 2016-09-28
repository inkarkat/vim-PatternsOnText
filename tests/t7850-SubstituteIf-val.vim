" Test replacing with predicate that uses v:val.

edit text.txt
%SubstituteIf /foo/BAR/g v:val.matchCount % 2

call vimtest#SaveOut()
call vimtest#Quit()
