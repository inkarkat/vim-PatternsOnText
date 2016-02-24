" Test navigation of unique lines in the entire buffer.

let s:lnums = [12, 8, 6, 3, 1]
call vimtest#StartTap()
call vimtap#Plan(len(s:lnums))

edit duplicateLines.txt
1
PrintUniqueLinesIgnoring

for s:lnum in s:lnums
    call vimtap#Is(getpos('.')[1:2], [s:lnum, 1], 'jump position')
    execute "normal! \<C-o>"
endfor

call vimtest#Quit()
