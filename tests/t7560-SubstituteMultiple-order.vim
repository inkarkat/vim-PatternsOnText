" Test pair ordering when multiple same patterns.

edit text.txt
%SubstituteMultiple /x/X/ /foo/first/ /foo/second/ /y/Y/ /foo/third/ g

call vimtest#SaveOut()
call vimtest#Quit()
