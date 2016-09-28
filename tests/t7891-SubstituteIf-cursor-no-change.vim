" Test that the cursor resides on the original line when no replacements.

edit text.txt
1normal! 3O
3
%SubstituteIf/\<...\>/XXX/g 1 == 0

call vimtest#StartTap()
call vimtap#Plan(3)
call vimtap#Is(getpos('.'), [0, 3, 1, 0], 'cursor at the non-indent start of the original line')
call vimtap#Is(getpos("'["), [0, 1, 1, 0], 'change marks start at the command range')
call vimtap#Is(getpos("']"), [0, 6, 1, 0], 'change marks end at the command range')

call vimtest#Quit()
