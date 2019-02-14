" Test translating matches via API with a Funcref that uses the argument.

function! MyFunc( context )
    return submatch(0) . a:context.matchCount
endfunction
edit text.txt
call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#Is(PatternsOnText#Translate#Translate('%', 0, '/', '\<...\>', function('MyFunc'), 'g'), 1, 'translate with Funcref')

call vimtest#SaveOut()
call vimtest#Quit()
