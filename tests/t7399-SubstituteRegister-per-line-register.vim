" Test replacing individual lines in pattern and replacement registers.

let @a = "foobar\nfoo\nFOObar"
let @b = "hiho\nFOO\nXXXXXX"
edit text.txt
%SubstituteMultipleExpr /@a/@b/g

call vimtest#SaveOut()
call vimtest#Quit()
