" Test command invocation with a pattern and command that contain a bar.

edit ranges.txt
call vimtest#StartTap()
call vimtap#Plan(1)
try
    /middle/,$RangeDo /begin\|bar/,/end\|baz/ execute "normal! I( \<Esc>" | execute "normal! A )\<Esc>"
    call vimtap#Pass('bar is parsed as belonging inside the pattern')
catch
    call vimtap#Fail('bar inside pattern should not end command')
    call vimtap#Diag(v:exception)
endtry

call vimtest#SaveOut()
call vimtest#Quit()
