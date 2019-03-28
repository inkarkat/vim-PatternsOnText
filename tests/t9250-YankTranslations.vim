" Test yanking the translations into the default register with the default template.

edit text.txt
1
SubstituteTranslate /\<...\>/BAR/BAZ/QUX/QUY/g

call vimtest#StartTap()
call vimtap#Plan(1)

YankTranslations

call vimtap#Is(@", ":'[,']substitute/BAR/foo/g\n:'[,']substitute/BAZ/fox/g\n:'[,']substitute/QUX/bar/g\n:'[,']substitute/QUY/baz/g\n", 'yanked translations')

call vimtest#SaveOut()
call vimtest#Quit()
