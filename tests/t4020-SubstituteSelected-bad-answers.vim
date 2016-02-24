" Test error when supplying no or invalid answers.

call vimtest#StartTap()
call vimtap#Plan(8)

edit text.txt
" Perform a first substitution so that there are previous answers. Tests that
" they are not taken, though.
1SubstituteSelected/\<...\>/XXX/g yn
let @/ = 'initial'
call histadd('search', @/)
call vimtap#err#Errors('Missing or invalid answers', '%SubstituteSelected/foo/XXX/g', 'error on missing answers')
call vimtap#Is(@/, 'initial', ':SubstituteSelected does not set last search pattern bad command')
call vimtap#Is(histget('search', -1), 'initial', ':SubstituteSelected fills search history on bad command')

call vimtap#err#Errors('Missing or invalid answers', '%SubstituteSelected/foo/XXX/g bad?!', 'error on very invalid answers')

call vimtap#err#Errors('Missing or invalid answers', '%SubstituteSelected/foo/XXX/ynyn,2;3', 'error on barely invalid answers')

let @/ = 'initial'
call histadd('search', @/)
call vimtap#err#Errors('Preceding position 2 after position 4', '%SubstituteSelected/foo/XXX/ynyn-2', 'position error')
call vimtap#Is(@/, 'initial', ':SubstituteSelected does not set last search pattern bad command')
call vimtap#Is(histget('search', -1), 'initial', ':SubstituteSelected fills search history on bad command')

call vimtest#Quit()
