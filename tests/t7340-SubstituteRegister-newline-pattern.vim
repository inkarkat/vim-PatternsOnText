" Test registers using a pattern with newline and CR atoms and literal newline.
" Tests that \r and a literal newline do not match at EOL.

let @a = ';\nShe'
let @b = ': They'
let @c = '"\rWe'
let @d = '``:'
let @e = "and foo!\n"
let @f = 'and what?'
edit text.txt
%SubstituteRegister a=b c=d e=f

call vimtest#SaveOut()
call vimtest#Quit()
