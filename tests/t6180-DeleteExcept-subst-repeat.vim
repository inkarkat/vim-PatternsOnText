" Test reuse of pattern, replacement, and flags when doing delete after :substitute.

edit text.txt
1substitute/\<f..\>/{redacted}/gi
3DeleteExcept

":DeleteExcept, unlike :SubstituteExcept, does not reuse the :s_flags (only
" the last search pattern). Therefore, even when the 'g' flag is omitted from
" the :substitute, the deletion is global.
1substitute/\<\l\+\>/\U&/
2DeleteExcept

call vimtest#SaveOut()
call vimtest#Quit()
