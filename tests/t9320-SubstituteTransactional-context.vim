" Test replacing matches using the context.

edit text.txt
1SubstituteTransactional #\<...\>#\=v:val.matchCount . '/' . v:val.matchNum#g
2SubstituteTransactional /\<...\>/\='[' . v:val.matchText . ']'/g
3SubstituteTransactional /\<...\>/\='[' . v:val.startPos[1] . '-' . v:val.endPos[1] . ']'/g

call vimtest#SaveOut()
call vimtest#Quit()
