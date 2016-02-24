" Test passing a minimal pair consisting of only a pattern.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#ErrorsLike('^E486: .*: \\(FOO\\)\\|\\(minimal-pair\\)', '%SubstituteMultiple /FOO/BAR/ minimal-pair', 'Pattern not found error shown')

%SubstituteMultiple /FOO/BAR/ fault

call vimtest#SaveOut()
call vimtest#Quit()
