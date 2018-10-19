" Test translating persisted matches through an enumeration of items in a line, now with case-insensitive matching.
" Test that new items are used.

edit text.txt
1
SubstituteTranslate /\<...\>/BAR/BAZ/QUX/QUY/g

3SubstituteTranslate /\<...\>/XXX/YYY/gi

call vimtest#SaveOut()
call vimtest#Quit()
