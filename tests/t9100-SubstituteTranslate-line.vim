" Test translating matches through an enumeration of items in a line.

edit text.txt
1
SubstituteTranslate /\<...\>/BAR/BAZ/QUX/QUY/g

call vimtest#SaveOut()
call vimtest#Quit()
