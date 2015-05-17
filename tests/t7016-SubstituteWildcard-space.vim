" Test command invocation with a pair that contains an escaped space.

if exists('+shellslash')
    set shellslash  " For reproducible results also on Windows.
endif

edit text.txt
%SubstituteWildcard foo=F\ \\ \ and\ =\ or\  g

call vimtest#SaveOut()
call vimtest#Quit()
