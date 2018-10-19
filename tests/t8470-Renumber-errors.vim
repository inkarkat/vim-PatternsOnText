" Test syntax error in renumbering.

edit numbers.txt

call vimtest#StartTap()
call vimtap#Plan(6)

call vimtap#err#Errors('Missing separators around /{pattern}/', 'Renumber foo bar', 'pattern not delimited')
call vimtap#err#Errors('Missing separators around /{pattern}/', 'Renumber 1.234.567/foo/444', 'start not a number')
call vimtap#err#ErrorsLike('E767: ', 'Renumber 1234/foo/444.555.666', 'offset not a number')
call vimtap#err#ErrorsLike('^E486: ', '1Renumber /doesNotExist/', 'pattern not found')
call vimtap#err#ErrorsLike('^E767: ', '6,9Renumber //FOO/', 'invalid format')
call vimtap#err#ErrorsLike('^E766: ', '11,13Renumber //%d-%x-%d/', 'too many references in format')

call vimtest#SaveOut()
call vimtest#Quit()
