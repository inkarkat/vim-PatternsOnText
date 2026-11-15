" Test replacing nine List expr.

edit text.txt
%SubstituteExpr [['foo', 'FOO'], ['ba[rz]', 'XXX'], ['fault!', 'problem?'], ['shout', 'yell'], ['She', 'He'], ['NOT', 'totally'], ['agree', 'sneeze'], ['need', 'want'], ['!', '?']] g

call vimtest#SaveOut()
call vimtest#Quit()
