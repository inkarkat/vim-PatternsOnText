" Test translating matches through an enumeration of items in a line.

edit text.txt
1
SubstituteTranslate /\<...\>/B\/R/|\/\\/Q\/X/Q\/Y/g

call vimtest#SaveOut()
call vimtest#Quit()
