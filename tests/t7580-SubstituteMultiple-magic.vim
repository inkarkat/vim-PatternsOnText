" Test changing magic.

edit text.txt
%SubstituteMultiple /\V[1]/XXX/ /\<fo[ox]/zup/ /\V.\s/?/ g

call vimtest#SaveOut()
call vimtest#Quit()
