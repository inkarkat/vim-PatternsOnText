" Test replacing with expression that uses v:val.

edit text.txt
%SubstituteExecute /foo/g if v:val.replacementCount < 5 | return col('.') % 2 ? 'XXX' : 'YYY' | endif

call vimtest#SaveOut()
call vimtest#Quit()
