" Test deletion of ranges in the current fold.
" Tests that all folded lines are considered, not just the cursor line.

edit ranges.txt

1,/middle/-1fold
/middle/,$fold

$DeleteRanges /begin/,/end/
1DeleteRanges! /{/+1,/}/-1

call vimtest#SaveOut()
call vimtest#Quit()
