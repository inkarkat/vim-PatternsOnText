" Test translating matches via API with an expression that uses v:val.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#Is(PatternsOnText#Translate#Translate('', '%', 0, '/', '\<...\>', 'submatch(0) . v:val.matchCount', 'g'), 1, 'translate with expression')

call vimtest#SaveOut()
call vimtest#Quit()
