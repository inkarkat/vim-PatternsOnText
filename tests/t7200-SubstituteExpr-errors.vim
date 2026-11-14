" Test error on invalid expressions.

call vimtest#StartTap()
call vimtap#Plan(7)

edit text.txt
call vimtap#err#Errors('No expression', '%SubstituteExpr ', 'No expression error shown due to no previous expression')
call vimtap#err#Errors('Expression needs to be {pattern: replacement} or [[pattern, replacement], ...]', '%SubstituteExpr 42', 'Expression syntax error shown due to returning a literal Number')
call vimtap#err#Errors('Expression needs to be {pattern: replacement} or [[pattern, replacement], ...]', '%SubstituteExpr v:version', 'Expression syntax error shown due to returning a Number')
call vimtap#err#Errors('Not a [pattern, replacement] pair: 42', '%SubstituteExpr [42]', 'Expression syntax error shown due to returning a List containing a literal Number')
call vimtap#err#Errors('Not a [pattern, replacement] pair: 42', '%SubstituteExpr [["pat", "repl"], 42]', 'Expression syntax error shown due to returning a List containing not just a [pattern, replacement] pairs')
call vimtap#err#Errors('Not a [pattern, replacement] pair: [1, 2, 3]', '%SubstituteExpr [["pat", "repl"], [1, 2, 3], ["moar", "here"]]', 'Expression syntax error shown due to returning a List containing a 3-element pair')
call vimtap#err#Errors('No patterns', '%SubstituteExpr [] g', 'No patterns error shown due to empty expression result')

call vimtest#Quit()
