" Test replacing expr matches containing newline literally.
" Tests that literal CR and \n atom do not match.

edit text.txt
%SubstituteExpr [[";\nShe", ': They'], ['"\rWe', '``:'], ['and foo!\n', 'and what?']] P

call vimtest#SaveOut()
call vimtest#Quit()
