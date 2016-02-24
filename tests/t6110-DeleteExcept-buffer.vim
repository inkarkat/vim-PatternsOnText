" Test deleting non-matches in the buffer.

let @/ = 'initial'
edit text.txt
%DeleteExcept/\<...\>/

call vimtest#StartTap()
call vimtap#Plan(2)
call vimtap#Is(@/, '\<...\>', ':DeleteExcept sets last search pattern')
call vimtap#Is(histget('search', -1), '\<...\>', ':DeleteExcept fills search history')

call vimtest#SaveOut()
call vimtest#Quit()
