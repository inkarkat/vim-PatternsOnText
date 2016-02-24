" Test command execution errors.

edit ranges.txt

call vimtest#StartTap()
call vimtap#Plan(1)
try
    RangeDo /begin/,/end/ if getline('.') =~# '\<...\>' | s/.*/&&/ | endif | if getline('.') =~# 'bar' | 999delete _ | endif
    call vimtap#Fail('expected exception')
catch
    call vimtap#err#ThrownLike('^E16: ', 'exception thrown')
endtry

call vimtest#SaveOut()
call vimtest#Quit()
