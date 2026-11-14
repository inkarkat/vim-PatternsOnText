" Test using a replacement with literal newline and CR.

edit text.txt
%SubstituteExpr [['\. ', "\n"], [' && ', "\r"]]

call vimtest#SaveOut()
call vimtest#Quit()
