" Test replacing ten pair matches.
" Tests that the implementation avoids E872: (NFA regexp) Too many '('

edit text.txt
%SubstituteMultipleExpr /['foo', 'ba[rz]', 'fault!', 'shout', 'She', 'NOT', 'agree', 'need', '!', 'We']/['FOO', 'XXX', 'problem?', 'yell', 'He', 'totally', 'sneeze', 'want', '?', 'All']/g

call vimtest#SaveOut()
call vimtest#Quit()
