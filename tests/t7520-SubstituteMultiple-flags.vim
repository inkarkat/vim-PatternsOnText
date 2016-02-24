" Test replacing pair matches with flags.

edit text.txt
3SubstituteMultiple /foo/FOO/ gi
set gdefault
1SubstituteMultiple /o/X/ g

call vimtest#SaveOut()
call vimtest#Quit()
