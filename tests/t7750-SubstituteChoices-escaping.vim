" Test replacing with choices containing an escaped separator.

let g:IngoLibrary_QueryChoices = ['FOO/BAR', '|/\', '///', 'FOO/BAR']
edit text.txt
1
SubstituteChoices /foo/FOO\/BAR/|\/\\/\/\/\//g

call vimtest#SaveOut()
call vimtest#Quit()
