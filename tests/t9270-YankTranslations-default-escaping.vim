" Test yanking the translations with the default :substitute escaping.

edit text.txt
1
SubstituteTranslate /\<...\>/&&&/\\\\\\/~~~/END/g

call vimtest#StartTap()
call vimtap#Plan(1)

YankTranslations

call vimtap#Is(@", ":'[,']substitute/&&&/foo/g\n:'[,']substitute/\\\\\\\\\\\\/fox/g\n:'[,']substitute/\\~\\~\\~/bar/g\n:'[,']substitute/END/baz/g\n", 'yanked translations')

call vimtest#Quit()
