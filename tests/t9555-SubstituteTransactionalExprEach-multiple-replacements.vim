" Test using multiple replacements instead of patternIndex.

edit text.txt
%SubstituteTransactionalExprEach /['\ze\<...\>', '\<...\>\zs']/"{{\n}}"/g

call vimtest#SaveOut()
call vimtest#Quit()
