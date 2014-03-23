" Test passing invalid pair.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
try
    %SubstituteWildcard FOO=BAR no-pair
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Not a substitution: no-pair', 'error shown')
endtry

call vimtest#Quit()
