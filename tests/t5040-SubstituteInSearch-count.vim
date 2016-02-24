" Test substituting with count.

edit text.txt
let @/ = '\<...\>'
1SubstituteInSearch/[aeiou]/X/g 2

call vimtest#SaveOut()
call vimtest#Quit()
