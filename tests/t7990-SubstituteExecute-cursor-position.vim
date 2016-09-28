" Test that the cursor resides on the last line with replacements.

edit text.txt
1normal! >G
%SubstituteExecute /\<...\>/g if line('.') < 3 | return '[' . toupper(submatch(0)) . ']' | endif

call vimtest#StartTap()
call vimtap#Plan(3)
call vimtap#Is(getpos('.'), [0, 2, 2, 0], 'cursor at the non-indent start of the last line with replacements')
call vimtap#Is(getpos("'["), [0, 1, 1, 0], 'change marks start at the command range')
call vimtap#Is(getpos("']"), [0, 3, 1, 0], 'change marks end at the command range')

call vimtest#Quit()
