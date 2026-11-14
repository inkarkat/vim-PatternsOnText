" Test substitution via expression register in the buffer.

let @a = 'foo'
let @c = 'NOT'
let @e = '\<need\>'
let @= = 'remove(g:replacements, 0)'
let g:replacements = ['FIRST', 'SECOND', 'THIRD', 'FOURTH']
edit text.txt
%SubstituteRegister a== c== e== g

call vimtest#SaveOut()
call vimtest#Quit()
