" Test replacing every second instance in the buffer.

let @/ = 'initial'
edit text.txt
%SubstituteSelected/foo/XXX/g ny

call vimtest#StartTap()
call vimtap#Plan(2)
call vimtap#Is(@/, 'foo', ':SubstituteSelected sets last search pattern')
call vimtap#Is(histget('search', -1), 'foo', ':SubstituteSelected fills search history')

call vimtest#SaveOut()
call vimtest#Quit()
