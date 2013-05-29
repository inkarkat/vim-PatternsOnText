" Test error when the pattern doesn't match.

edit text.txt
%SubstituteSelected/doesNotExist/XXX/g yn

call vimtest#Quit()
