" Test error when the pattern doesn't match.

call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = 'initial'
edit text.txt
try
    %SubstituteSelected/doesNotExist/XXX/g yn
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('E486: Pattern not found: doesNotExist', 'error shown')
endtry
call vimtap#Is(@/, 'doesNotExist', ':SubstituteSelected sets last search pattern on no match error')
call vimtap#Is(histget('search', -1), 'doesNotExist', ':SubstituteSelected fills search history on no match error')

call vimtest#Quit()
