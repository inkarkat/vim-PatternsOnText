" Test replacing with predicate that uses v:val.

edit text.txt
%SubstituteExecute /\<...\>/g let prev = v:val.s | let v:val.s = submatch(0) | return (empty(prev) ? '???' : prev)

call vimtest#SaveOut()
call vimtest#Quit()
