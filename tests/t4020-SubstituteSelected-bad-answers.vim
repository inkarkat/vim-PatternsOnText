" Test error when supplying no or invalid answers.

edit text.txt
%SubstituteSelected/foo/XXX/g
%SubstituteSelected/foo/XXX/g bad?!

call vimtest#Quit()
