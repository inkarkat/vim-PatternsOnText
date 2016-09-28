" Test replacing with expression that later throws.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#Errors('Expression threw exception: BAAAH', '%SubstituteExecute /foo/g if line(".") == 3 | throw "BAAAH" | endif | return "XXX"', 'error shown')

call vimtest#SaveOut()
call vimtest#Quit()
