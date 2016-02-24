" Test error when supplying no or invalid answers.

call vimtest#StartTap()
call vimtap#Plan(2)

edit duplicates.txt
7normal! 6W
call vimtap#err#ErrorsLike('^E488: ', '.,$SubstituteSubsequent/\<...\>/XXX/g bad?!', 'Trailing characters error on very invalid answers')

call vimtap#err#ErrorsLike('^E488: ', '.,$SubstituteSubsequent/\<...\>/XXX/ynyn,2;3', 'Trailing characters error on barely invalid answers')

call vimtest#Quit()
