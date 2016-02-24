" Test navigation of lines matching passed pattern.

let s:lnums = [11, 9, 10, 7, 2, 1]
call vimtest#StartTap()
call vimtap#Plan(len(s:lnums))

edit duplicateLines.txt
1
PrintDuplicateLinesOf ^\cb..$

for s:lnum in s:lnums
    call vimtap#Is(getpos('.')[1:2], [s:lnum, 1], 'jump position')
    execute "normal! \<C-o>"
endfor

call vimtest#Quit()
