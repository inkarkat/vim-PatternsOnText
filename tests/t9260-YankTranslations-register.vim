" Test yanking the translations into the passed register.

edit text.txt
1
SubstituteTranslate /\<...\>/BAR/BAZ/QUX/QUY/g

call vimtest#StartTap()
call vimtap#Plan(3)

let @" = ''
YankTranslations a

call vimtap#Is(@", "", 'default register is untouched')
call vimtap#Is(@a, ":'[,']substitute/BAR/foo/g\n:'[,']substitute/BAZ/fox/g\n:'[,']substitute/QUX/bar/g\n:'[,']substitute/QUY/baz/g\n", 'yanked translations into register a')

YankTranslations b '/' . v:val.count . '/' . v:val.replacement . '/' . v:val.match . '/,'
call vimtap#Is(@b, "/1/BAR/foo/,/2/BAZ/fox/,/3/QUX/bar/,/4/QUY/baz/,", 'yanked custom translations into register b')

call vimtest#Quit()
