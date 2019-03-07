" Test using the test expression to skip matches.

edit text.txt
%SubstituteTransactional /\<...\>/\=v:val.matchCount . '-' . toupper(v:val.matchText)/gt/if submatch(0)=='foo'|throw 'skip'|endif/

call vimtest#SaveOut()
call vimtest#Quit()
