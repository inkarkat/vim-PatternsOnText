" Test translating persisted matches through an enumeration of items in a line.
" Test that new items appended to existing ones are used.
" Test that pattern can be omitted.

edit text.txt
1
SubstituteTranslate /\<...\>/BAR/BAZ/QUX/QUY/g

3SubstituteTranslate //BAR/BAZ/QUX/QUY/XXX/YYY/g

call vimtest#SaveOut()
call vimtest#Quit()
