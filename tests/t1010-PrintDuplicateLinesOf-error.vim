" Test error message when no duplicates of the current line found.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
1
try
    PrintDuplicateLinesOf
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No duplicate lines', 'error shown')
endtry

call vimtest#Quit()
