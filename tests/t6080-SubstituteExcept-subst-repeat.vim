" Test reuse of pattern, replacement, and flags when doing replacement after :substitute.

edit text.txt
1substitute/\<f..\>/{redacted}/gi
3SubstituteExcept

" Tests that, because the 'g' flag is omitted from the :substitute, only the
" text _before_ ("She") the first match ("said") is replaced.
1substitute/\<\l\+\>/\U&/
2SubstituteExcept

call vimtest#SaveOut()
call vimtest#Quit()
