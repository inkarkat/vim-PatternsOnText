" Test putting the translations at the beginning of the buffer with the default template.

edit text.txt
1
SubstituteTranslate /\<...\>/BAR/BAZ/QUX/QUY/g

0PutTranslations

call vimtest#SaveOut()
call vimtest#Quit()
