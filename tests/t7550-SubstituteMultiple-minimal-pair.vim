" Test passing a minimal pair consisting of only a pattern.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
try
    %SubstituteMultiple /FOO/BAR/ minimal-pair
    call vimtap#Fail('expected no match')
catch
    call vimtap#err#Thrown('E486: Pattern not found: \(FOO\)\|\(minimal-pair\)', 'no match error shown')
endtry

%SubstituteMultiple /FOO/BAR/ fault

call vimtest#SaveOut()
call vimtest#Quit()
