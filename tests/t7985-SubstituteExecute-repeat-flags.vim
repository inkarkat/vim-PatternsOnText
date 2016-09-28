" Test reuse of pattern, expression, but new flags when repeating substitution.

edit text.txt
%SubstituteExecute /\<...\>/ return v:val.matchCount . submatch(0)
%SubstituteExecute g

call vimtest#SaveOut()
call vimtest#Quit()
