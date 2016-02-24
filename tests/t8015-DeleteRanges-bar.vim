" Test command invocation with a pattern that contains a bar.

edit ranges.txt
call vimtest#StartTap()
call vimtap#Plan(1)
try
    /middle/,$DeleteRanges /begin\|bar/,/end\|baz/
    call vimtap#Pass('bar is parsed as belonging inside the pattern')
catch
    call vimtap#Fail('bar inside pattern should not end command')
    call vimtap#Diag(v:exception)
endtry

call vimtest#Quit()
