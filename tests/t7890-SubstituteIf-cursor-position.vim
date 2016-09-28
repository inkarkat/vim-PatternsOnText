" Test that the cursor resides on the last line with replacements.

edit text.txt
1normal! >G
%SubstituteIf/\<...\>/XXX/g line('.') % 2 == 0

call vimtest#StartTap()
call vimtap#Plan(3)
call vimtap#Is(getpos('.'), [0, 2, 2, 0], 'cursor at the non-indent start of the last line with replacements')
call vimtap#Is(getpos("'["), [0, 1, 1, 0], 'change marks start at the command range')
call vimtap#Is(getpos("']"), [0, 3, 1, 0], 'change marks end at the command range')

call vimtest#Quit()
