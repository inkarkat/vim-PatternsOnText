" Test navigation of blocks of ranges.

let s:lnums = [15, 9, 5, 1]
call vimtest#StartTap()
call vimtap#Plan(len(s:lnums))

edit ranges.txt
setlocal nomodifiable
1
PrintRanges /{/,/}/

for s:lnum in s:lnums
    call vimtap#Is(getpos('.')[1:2], [s:lnum, 1], 'jump position')
    execute "normal! \<C-o>"
endfor

call vimtest#Quit()
