" Test unescaping of different separators.

edit text.txt
%SubstituteMultiple /foobar/hi\/ho/ #foo#/!/# !fault\!!error\!\!\!! g

call vimtest#SaveOut()
call vimtest#Quit()
