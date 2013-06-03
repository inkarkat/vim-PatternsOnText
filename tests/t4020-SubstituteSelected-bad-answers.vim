" Test error when supplying no or invalid answers.

call vimtest#StartTap()
call vimtap#Plan(2)

edit text.txt
try
    %SubstituteSelected/foo/XXX/g
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Invalid arguments', 'error shown')
endtry

try
    %SubstituteSelected/foo/XXX/g bad?!
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Invalid arguments', 'error shown')
endtry

call vimtest#Quit()
