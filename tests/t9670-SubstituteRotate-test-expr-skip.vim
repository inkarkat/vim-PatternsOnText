" Test using the test expression to skip matches when rotating matches.

edit enumeration.txt
1,4SubstituteRotate /\[\w\+\]/1/gt/if submatch(0)=='[three]'|throw 'skip'|endif/

call vimtest#SaveOut()
call vimtest#Quit()
