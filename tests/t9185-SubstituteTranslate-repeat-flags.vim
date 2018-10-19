" Test reuse of pattern, expression, but new flags when repeating substitution.

edit text.txt
1SubstituteTranslate /\<...\>/\=submatch(0) . v:val.matchCount/
2SubstituteTranslate g
3SubstituteTranslate gi

call vimtest#SaveOut()
call vimtest#Quit()
