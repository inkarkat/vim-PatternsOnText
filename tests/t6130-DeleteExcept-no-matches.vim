" Test error when the pattern doesn't match.

edit text.txt
execute "2normal! o \<Esc>"
execute "1normal! o\<Esc>"
%DeleteExcept/doesNotExist/

call vimtest#SaveOut()
call vimtest#Quit()
