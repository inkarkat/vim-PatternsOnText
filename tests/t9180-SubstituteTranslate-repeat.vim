" Test reuse of pattern, flags, and expression when repeating substitution.

edit text.txt
3SubstituteTranslate /\<...\>/\=submatch(0) . v:val.matchCount/g
2SubstituteTranslate
1SubstituteTranslate

call vimtest#SaveOut()
call vimtest#Quit()
