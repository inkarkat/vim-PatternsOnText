" Test error when the inner pattern doesn't match.

edit text.txt
let @/ = '\<...\>'
%SubstituteInSearch/doesNotExist/XXX/g

call vimtest#Quit()
