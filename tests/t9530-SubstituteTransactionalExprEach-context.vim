" Test replacing matches using the context.

edit text.txt
%SubstituteTransactionalExprEach #['\<...\>', '\<....\>', '\<agreed\>']#["\\=v:val.matchCount . '/' . v:val.matchNum", "\\='[' . v:val.matchText . ']'", "\\='<' . v:val.startPos[1] . '-' . v:val.endPos[1] . '>'"]#g

call vimtest#SaveOut()
call vimtest#Quit()
