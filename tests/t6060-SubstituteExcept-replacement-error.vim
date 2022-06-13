" Test syntax error in special replacement.

if v:version < 801 || v:version == 801 && ! has('patch1061')
    call vimtest#SkipOut('When substitute string throws error, substitute happens anyway')
endif

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#ErrorsLike("^E110: .* ')'", '1SubstituteExcept/\<...\>/\=string((((submatch(1)/', 'Missing ) error shown')

call vimtest#SaveOut()
call vimtest#Quit()
