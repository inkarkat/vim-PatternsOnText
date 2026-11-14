" Test using a pattern with newline and CR atoms and literal newline.
" Tests that \r and a literal newline do not match at EOL.

edit text.txt
%SubstituteExpr [[';\nShe', ': They'], ['"\rWe', '``:'], ["and foo!\n", 'and what?']]

call vimtest#SaveOut()
call vimtest#Quit()
