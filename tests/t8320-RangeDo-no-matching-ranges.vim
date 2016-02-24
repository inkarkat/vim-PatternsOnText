" Test error when there are no ranges to be executed on.

edit ranges.txt

call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#Errors('No matching ranges', '%RangeDo /doesnot/,/exists/ delete _', 'error shown')

call vimtest#Quit()
