" Test using a register replacement with literal newline and CR.
" Tests that \r register contents introduce two newlines (one for the \r and one for linewise register).

let @a = '\. '
let @b =  "\n"
let @c = ' && '
let @d = "\r"
edit text.txt
%SubstituteRegister a=b c=d

call vimtest#SaveOut()
call vimtest#Quit()
