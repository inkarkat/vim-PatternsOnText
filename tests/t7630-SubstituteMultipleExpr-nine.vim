" Test replacing nine pair matches.

edit text.txt
%SubstituteMultipleExpr /['foo', 'ba[rz]', 'fault!', 'shout', 'She', 'NOT', 'agree', 'need', '!']/['FOO', 'XXX', 'problem?', 'yell', 'He', 'totally', 'sneeze', 'want', '?']/g

call vimtest#SaveOut()
call vimtest#Quit()
