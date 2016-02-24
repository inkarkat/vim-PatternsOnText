" Test error when the pattern doesn't match.
" Tests that empty lines remain empty, but when there's whitespace, it is
" replaced.

edit text.txt
execute "2normal! o \<Esc>"
execute "1normal! o\<Esc>"
%SubstituteExcept/doesNotExist/{redacted}/

call vimtest#SaveOut()
call vimtest#Quit()
