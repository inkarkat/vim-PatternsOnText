" Test replacing ten List expr.
" Tests that the implementation avoids E872: (NFA regexp) Too many '('

edit text.txt
%SubstituteExpr [['foo', 'FOO'], ['ba[rz]', 'XXX'], ['fault!', 'problem?'], ['shout', 'yell'], ['She', 'He'], ['NOT', 'totally'], ['agree', 'sneeze'], ['need', 'want'], ['!', '?'], ['We', 'All']] g

call vimtest#SaveOut()
call vimtest#Quit()
