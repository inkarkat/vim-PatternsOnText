" Test changing magic.

edit text.txt
%SubstituteTransactionalExprEach /['\V[1]', '\<fo[ox]', '\V.\s']/['XXX', 'zup', '?']/g

call vimtest#SaveOut()
call vimtest#Quit()
