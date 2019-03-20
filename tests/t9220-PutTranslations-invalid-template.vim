" Test putting the translations at the end of the buffer with an invalid template.

edit text.txt
1
SubstituteTranslate /\<...\>/BAR/BAZ/QUX/QUY/g

call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#Errors('E121: Undefined variable: blah', '$PutTranslations v:val.count * 2 + [blah', 'undefined variable error')

call vimtest#SaveOut()
call vimtest#Quit()
