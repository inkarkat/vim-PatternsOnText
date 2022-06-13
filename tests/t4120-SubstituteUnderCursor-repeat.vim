" Test reuse of pattern, replacement, flags when replacing only under the cursor.

edit text.txt

1normal! e
SubstituteUnderCursor/\<foo\>/FIRST/i

3normal! 3w
SubstituteUnderCursor
3normal! 4W
SubstituteUnderCursor

call vimtest#SaveOut()
call vimtest#Quit()
