" Test error when the pattern doesn't match.

call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = 'initial'
edit duplicates.txt
7normal! 6W
call vimtap#err#ErrorsLike('^E486: .*: .*doesNotExist', '.,$SubstituteSubsequent/doesNotExist/XXX/g yn', 'Pattern not found error shown')
call vimtap#Is(@/, 'doesNotExist', ':SubstituteSubsequent sets last search pattern on no match error')
call vimtap#Is(histget('search', -1), 'doesNotExist', ':SubstituteSubsequent fills search history on no match error')

call vimtest#Quit()
