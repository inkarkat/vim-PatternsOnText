" Test replacing pattern only under the cursor.

edit text.txt
3
SubstituteUnderCursor/\<foo\>/NO-MATCH/

3normal! 3w
SubstituteUnderCursor/\<foo\>/FIRST/

1normal! 2f(
SubstituteUnderCursor/\<foo\>/NOT-AFTER/
1normal! 2f&l
SubstituteUnderCursor/\<foo\>/NOT-BEFORE/
1normal! Wl
SubstituteUnderCursor/\<foo\>/MIDDLE-\U&/
1normal! e
SubstituteUnderCursor/\<foo\>/END/

call vimtest#SaveOut()
call vimtest#Quit()
