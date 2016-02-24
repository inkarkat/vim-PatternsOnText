" Test replacing instances of the previous search after the cursor in a single line.

call setline(1, 'my foo#bar is do#ne in he#re for th#at')
1normal! 4W
let @/ = '\w#\w'
SubstituteSubsequent##XXX#g

call vimtest#SaveOut()
call vimtest#Quit()
