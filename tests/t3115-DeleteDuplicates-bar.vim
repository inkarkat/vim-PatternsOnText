" Test command invocation with a pattern that contains a bar.

edit duplicates.txt
call vimtest#StartTap()
call vimtap#Plan(1)
try
    %DeleteDuplicates \<\(\w\|!\)\+\>
    call vimtap#Pass('bar is parsed as belonging inside the pattern')
catch
    call vimtap#Fail('bar inside pattern should not end command')
    call vimtap#Diag(v:exception)
endtry

call vimtest#Quit()