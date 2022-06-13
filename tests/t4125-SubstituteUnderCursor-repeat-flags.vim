" Test reuse of patterns and replacements under cursor when repeating with new flags.

edit text.txt

3normal! 4W
SubstituteUnderCursor/\<Foo\>/FIRST/

3normal! 3w
SubstituteUnderCursor e
1normal! e
SubstituteUnderCursor i

call vimtest#SaveOut()
call vimtest#Quit()
