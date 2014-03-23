" Test error when there are no ranges to be deleted.

edit ranges.txt

call vimtest#StartTap()
call vimtap#Plan(1)

try
    %DeleteRanges /doesnot/,/exists/
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No matching ranges', 'error shown')
endtry

call vimtest#Quit()
