" Test replacing pair matches with flags.

edit text.txt
3SubstituteWildcard foo=FOO gi
set gdefault
1SubstituteWildcard o=X g

call vimtest#SaveOut()
call vimtest#Quit()
