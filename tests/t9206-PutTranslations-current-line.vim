" Test putting the translations at the current line with the default template.

edit text.txt
1
SubstituteTranslate /\<...\>/BAR/BAZ/QUX/QUY/g

2
PutTranslations

call vimtest#SaveOut()
call vimtest#Quit()
