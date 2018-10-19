" Test translating matches with another expression.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
let g:items = ['AAA', 'BBB', 'CCC', 'DDD', 'EEE', 'FFF', 'GGG', 'HHH', 'III']
%SubstituteTranslate /\<...\>/\=remove(g:items, 0)/g

call vimtap#Is(g:items, ['III'], 'one item left in List')

call vimtest#SaveOut()
call vimtest#Quit()
