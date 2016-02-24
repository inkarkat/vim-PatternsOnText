" Test error when there are no ranges to be deleted.

edit ranges.txt

call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#Errors('No matching ranges', '%DeleteRanges /doesnot/,/exists/', 'error shown')

call vimtest#Quit()
