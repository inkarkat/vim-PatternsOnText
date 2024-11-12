" Test replacing with expression in the buffer.

edit text.txt
%SubstituteExecute /\<...\>/g if submatch(0) ==? 'foo' | return 'ooo' | elseif col('.') == 1 | return 'HE' | else | return toupper(submatch(0)) | endif

call vimtest#SaveOut()
call vimtest#Quit()
