" Test replacing one pair match in a line.

edit text.txt
2substitute#my#my/her/our#
%SubstituteMultiple /foobar/hi\/ho/ /foo/|\/\\\\/ /my\/her\/our/X\ X\ X/ g

call vimtest#SaveOut()
call vimtest#Quit()
