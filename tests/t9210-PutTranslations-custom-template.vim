" Test putting the translations at the end of the buffer with a customized template.

edit text.txt
1
SubstituteTranslate /\<...\>/BAR/BAZ/QUX/QUY/g

$PutTranslations v:val.count . ': [' . v:val.replacement . ']=[' . v:val.match . '], '

call vimtest#SaveOut()
call vimtest#Quit()
