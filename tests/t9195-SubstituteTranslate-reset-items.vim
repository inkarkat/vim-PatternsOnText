" Test clearing memoizations of items.

edit text.txt
%SubstituteTranslate! /\<...\>/GGG/HHH/III/JJJ/KKK/LLL/MMM/NNN/OOO/PPP/g
%SubstituteTranslate! /\<....\>/AAAA/BBBB/CCCC/DDDD/EEEE/g

call vimtest#SaveOut()
call vimtest#Quit()
