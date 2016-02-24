" Test navigation of duplicate lines in the entire buffer.

let s:lnums = [11, 9, 5, 4, 10, 7, 2, 1]
call vimtest#StartTap()
call vimtap#Plan(len(s:lnums))

edit duplicateLines.txt
1
PrintDuplicateLinesIgnoring

for s:lnum in s:lnums
    call vimtap#Is(getpos('.')[1:2], [s:lnum, 1], 'jump position')
    execute "normal! \<C-o>"
endfor

call vimtest#Quit()
