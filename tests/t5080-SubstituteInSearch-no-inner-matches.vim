" Test error when the inner pattern doesn't match.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
let @/ = '\<...\>'
call vimtap#err#Errors('Pattern not found: doesNotExist', '%SubstituteInSearch/doesNotExist/XXX/g', 'error shown')

call vimtest#Quit()
