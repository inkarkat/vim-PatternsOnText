" Test replacing ten pair matches.
" Tests that the implementation avoids E872: (NFA regexp) Too many '('

edit text.txt
%SubstituteMultiple /foo/FOO/ /ba[rz]/XXX/ #fault!#problem?# #shout#yell# @She@He@ @NOT@totally@ @agree@sneeze@ @need@want@ @!@?@ /We/All/ g

call vimtest#SaveOut()
call vimtest#Quit()
