" Test translating matches with an expression that skips some matches.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#Errors('Incomplete substitution: Need 2 more items', "%SubstituteTranslate /\\<...\\>/\\=col('.') > 36 ? [] : submatch(0) . col('.')/g", 'incomplete error')

call vimtest#SaveOut()
call vimtest#Quit()
