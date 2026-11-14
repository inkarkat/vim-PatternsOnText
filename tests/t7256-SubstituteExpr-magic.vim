" Test changing magic in expr pattern.

edit text.txt
%SubstituteExpr [['\V[1]', 'XXX'], ['\<fo[ox]', 'zup'], ['\V.\s', '?']] g

call vimtest#SaveOut()
call vimtest#Quit()
