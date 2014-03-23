" Test error when the pattern doesn't match.

call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = 'initial'
edit duplicates.txt
7normal! 6W
try
    .,$SubstituteSubsequent/doesNotExist/XXX/g yn
    call vimtap#Fail('expected error')
catch
    call vimtap#err#ThrownLike('E486: Pattern not found: .*doesNotExist', 'error shown')
endtry
call vimtap#Is(@/, 'doesNotExist', ':SubstituteSubsequent sets last search pattern on no match error')
call vimtap#Is(histget('search', -1), 'doesNotExist', ':SubstituteSubsequent fills search history on no match error')

call vimtest#Quit()
