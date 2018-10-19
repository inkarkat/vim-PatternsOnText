" Test translating matches in the buffer in two calls.

edit text.txt
silent! %SubstituteTranslate /\<...\>/BARI/BAZI/QUXI/QUYI/g
%SubstituteTranslate //AAAA/BBBB/CCCC/DDDD/g

call vimtest#SaveOut()
call vimtest#Quit()
