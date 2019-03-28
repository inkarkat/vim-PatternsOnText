" Test using patternIndex within test expression to skip matches.

edit text.txt
%SubstituteTransactionalExpr /['\%3l\<[Ff]oo\>', '\<...\>']/"\\=v:val.matchCount . '-' . toupper(v:val.matchText)"/gt/if v:val.patternIndex == 0|throw 'skip'|endif/

call vimtest#SaveOut()
call vimtest#Quit()
