" Test error when supplying no or invalid answers.

call vimtest#StartTap()
call vimtap#Plan(2)

edit duplicates.txt
7normal! 6W
try
    .,$SubstituteSubsequent/\<...\>/XXX/g bad?!
    call vimtap#Fail('expected error on very invalid answers')
catch
    call vimtap#err#Thrown('E488: Trailing characters', 'error on very invalid answers')
endtry

try
    .,$SubstituteSubsequent/\<...\>/XXX/ynyn,2;3
    call vimtap#Fail('expected error on barely invalid answers')
catch
    call vimtap#err#Thrown('E488: Trailing characters', 'error on barely invalid answers')
endtry

call vimtest#Quit()
