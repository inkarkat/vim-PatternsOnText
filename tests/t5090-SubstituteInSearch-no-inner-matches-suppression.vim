" Test suppression of the error when the inner pattern doesn't match.

edit text.txt
let @/ = '\<...\>'
%SubstituteInSearch/doesNotExist/XXX/ge
echomsg 'end'

call vimtest#Quit()
