" Test reuse of patterns, replacements, and flags when repeating register substitution.

let @a = 'foobar'
let @b = 'hiho'
let @c = 'foo'
let @d = 'FOO'
let @e = 'FOObar'
let @f = 'XXXXXX'
edit text.txt
1SubstituteRegister a=b c=d e=f g
3SubstituteRegister

call vimtest#SaveOut()
call vimtest#Quit()
