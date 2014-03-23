" Test error when supplying no or invalid answers.

call vimtest#StartTap()
call vimtap#Plan(8)

edit text.txt
" Perform a first substitution so that there are previous answers. Tests that
" they are not taken, though.
1SubstituteSelected/\<...\>/XXX/g yn
let @/ = 'initial'
call histadd('search', @/)
try
    %SubstituteSelected/foo/XXX/g
    call vimtap#Fail('expected error on missing answers')
catch
    call vimtap#err#Thrown('Missing or invalid answers', 'error on missing answers')
endtry
call vimtap#Is(@/, 'initial', ':SubstituteSelected does not set last search pattern bad command')
call vimtap#Is(histget('search', -1), 'initial', ':SubstituteSelected fills search history on bad command')

try
    %SubstituteSelected/foo/XXX/g bad?!
    call vimtap#Fail('expected error on very invalid answers')
catch
    call vimtap#err#Thrown('Missing or invalid answers', 'error on very invalid answers')
endtry

try
    %SubstituteSelected/foo/XXX/ynyn,2;3
    call vimtap#Fail('expected error on barely invalid answers')
catch
    call vimtap#err#Thrown('Missing or invalid answers', 'error on barely invalid answers')
endtry

let @/ = 'initial'
call histadd('search', @/)
try
    %SubstituteSelected/foo/XXX/ynyn-2
    call vimtap#Fail('expected position error')
catch
    call vimtap#err#Thrown('Preceding position 2 after position 4', 'position error')
endtry
call vimtap#Is(@/, 'initial', ':SubstituteSelected does not set last search pattern bad command')
call vimtap#Is(histget('search', -1), 'initial', ':SubstituteSelected fills search history on bad command')

call vimtest#Quit()
