" Test replacing literal expr matches with replacement containing literal newline and CR.

edit text.txt
%SubstituteExpr [['^foo', "animal\n"], [' NOT ', "\n_not_\n"], ['Foo', "FOO\rBAR"]] gR

call vimtest#SaveOut()
call vimtest#Quit()
