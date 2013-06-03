" Test error when supplying no or invalid answers.

call vimtest#StartTap()
call vimtap#Plan(4)

edit text.txt
try
    %SubstituteSelected/foo/XXX/g
    call vimtap#Fail('expected error on missing answers')
catch
    call vimtap#err#Thrown('Invalid arguments', 'error on missing answers')
endtry

try
    %SubstituteSelected/foo/XXX/g bad?!
    call vimtap#Fail('expected error on very invalid answers')
catch
    call vimtap#err#Thrown('Invalid arguments', 'error on very invalid answers')
endtry

try
    %SubstituteSelected/foo/XXX/ynyn,2;3
    call vimtap#Fail('expected error on barely invalid answers')
catch
    call vimtap#err#Thrown('Invalid arguments', 'error on barely invalid answers')
endtry

try
    %SubstituteSelected/foo/XXX/ynyn-2
    call vimtap#Fail('expected position error')
catch
    call vimtap#err#Thrown('Preceding position 2 after position 4', 'position error')
endtry

call vimtest#Quit()
