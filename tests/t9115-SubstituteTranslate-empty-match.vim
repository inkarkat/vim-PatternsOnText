" Test translating empty match.

edit text.txt
1SubstituteTranslate /foo\zs\w*/BAR/BAZ/QUX/QUY/g

call vimtest#SaveOut()
call vimtest#Quit()
