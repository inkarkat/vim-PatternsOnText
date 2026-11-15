" Test replacing nine pair matches.

edit text.txt
%SubstituteMultiple /foo/FOO/ /ba[rz]/XXX/ #fault!#problem?# #shout#yell# @She@He@ @NOT@totally@ @agree@sneeze@ @need@want@ @!@?@ g

call vimtest#SaveOut()
call vimtest#Quit()
