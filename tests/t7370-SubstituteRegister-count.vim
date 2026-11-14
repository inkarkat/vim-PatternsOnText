" Test replacing expr matches with count.

let @a = 'o'
let @b = 'O'
let @c = 'x'
let @d = 'X'
let @e = 's'
let @f = 'S'
edit text.txt
1SubstituteRegister a=b c=d g 2
1SubstituteRegister e=f g2

call vimtest#SaveOut()
call vimtest#Quit()
