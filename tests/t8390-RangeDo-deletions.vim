" Test command execution that deletes lines.

edit ranges.txt

RangeDo /begin/,/end/ if getline('.') =~# 'foo' | .,+1delete _ | endif | if getline('.') =~# '\<..\>' | .+1 delete _ | endif

call vimtest#SaveOut()
call vimtest#Quit()
