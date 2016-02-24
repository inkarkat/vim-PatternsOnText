" Test command execution that adds lines.

set autoindent

edit ranges.txt

RangeDo /begin/,/end/ if getline('.') =~# 'foo' | execute "normal! Ovvv\<Esc>j" | endif | if getline('.') =~# '\<...\>' | execute "normal! o---\<Esc>" | endif

call vimtest#SaveOut()
call vimtest#Quit()
