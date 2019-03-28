" Test putting the translations at the end of the buffer with the default template.

edit text.txt
1
SubstituteTranslate /\<...\>/BAR/BAZ/QUX/QUY/g

$PutTranslations

call vimtest#SaveOut()
call vimtest#Quit()
