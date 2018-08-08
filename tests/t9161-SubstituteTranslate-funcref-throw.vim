" Test translating matches with a Funcref that throws an exception.

function! MyFunc( context )
    if submatch(0) ==# 'NOT'
	throw 'Identical transformation'
    endif
    return toupper(submatch(0))
endfunction
edit text.txt
call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#Errors('Expression threw exception: Identical transformation', '%SubstituteTranslate /\<...\>/MyFunc/g', 'error shown')

call vimtest#SaveOut()
call vimtest#Quit()
