" Test error when supplying no or invalid answers.

call vimtest#StartTap()
call vimtap#Plan(2)

edit duplicates.txt
7normal! 6W
call vimtap#err#Errors('E488: Trailing characters', '.,$SubstituteSubsequent/\<...\>/XXX/g bad?!', 'error on very invalid answers')

call vimtap#err#Errors('E488: Trailing characters', '.,$SubstituteSubsequent/\<...\>/XXX/ynyn,2;3', 'error on barely invalid answers')

call vimtest#Quit()
