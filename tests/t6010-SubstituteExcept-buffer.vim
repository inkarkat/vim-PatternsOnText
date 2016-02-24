" Test replacing non-matches in the buffer.

let @/ = 'initial'
edit text.txt
%SubstituteExcept/\<...\>/{redacted}/

call vimtest#StartTap()
call vimtap#Plan(2)
call vimtap#Is(@/, '\<...\>', ':SubstituteExcept sets last search pattern')
call vimtap#Is(histget('search', -1), '\<...\>', ':SubstituteExcept fills search history')

call vimtest#SaveOut()
call vimtest#Quit()
