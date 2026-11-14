" Test deleting via pattern-reg=_ in the buffer.

let @a = 'foobar'
let @c = 'foo'
let @e = 'FOObar'
edit text.txt
%SubstituteRegister a=_ c=_ e=_ g

call vimtest#SaveOut()
call vimtest#Quit()
