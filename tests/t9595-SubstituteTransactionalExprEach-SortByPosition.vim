" Test sorting by position.

let s:a = [1, 1]
let s:b = [1, 3]
let s:c = [1, 6]
let s:d = [1, 9]
let s:e = [2, 1]
let s:f = [2, 5]
let s:g = [2, 11]
let s:h = [3, 3]

call vimtest#StartTap()
call vimtap#Plan(10)

call vimtap#Is(sort([[s:a, s:c], [s:a, s:c]], 'PatternsOnText#Transactional#ExprEach#SortByPosition'), [[s:a, s:c], [s:a, s:c]], 'identical')
call vimtap#Is(sort([[s:d, s:f], [s:a, s:c]], 'PatternsOnText#Transactional#ExprEach#SortByPosition'), [[s:d, s:f], [s:a, s:c]], 'already later before earlier')
call vimtap#Is(sort([[s:a, s:c], [s:d, s:f]], 'PatternsOnText#Transactional#ExprEach#SortByPosition'), [[s:d, s:f], [s:a, s:c]], 'later before earlier')
call vimtap#Is(sort([[s:a, s:c], [s:b, s:d]], 'PatternsOnText#Transactional#ExprEach#SortByPosition'), [[s:b, s:d], [s:a, s:c]], 'overlapping later before earlier')
call vimtap#Is(sort([[s:a, s:e], [s:b, s:d]], 'PatternsOnText#Transactional#ExprEach#SortByPosition'), [[s:a, s:e], [s:b, s:d]], 'outer before inner')
call vimtap#Is(sort([[s:a, s:b], [s:a, s:c]], 'PatternsOnText#Transactional#ExprEach#SortByPosition'), [[s:a, s:c], [s:a, s:b]], 'overlapping same front longer before shorter')
call vimtap#Is(sort([[s:d, s:f], [s:e, s:f]], 'PatternsOnText#Transactional#ExprEach#SortByPosition'), [[s:e, s:f], [s:d, s:f]], 'overlapping same end shorter before longer')

call vimtap#Is(sort([[s:a, s:c], [s:b, s:d], [s:g, s:h], [s:d, s:f], [s:b, s:d], [s:d, s:f], [s:c, s:e], [s:b, s:g], [s:e, s:g], [s:a, s:h], [s:f, s:g]], 'PatternsOnText#Transactional#ExprEach#SortByPosition'),
\   reverse([[s:a, s:c], [s:b, s:d], [s:b, s:d], [s:c, s:e], [s:d, s:f], [s:d, s:f], [s:b, s:g], [s:e, s:g], [s:f, s:g], [s:a, s:h], [s:g, s:h]]), 'mixed long list')


call vimtap#Is(sort([[s:b, s:c, -1, 2], [s:b, s:c, -1, 0], [s:b, s:c, -1, 1]], 'PatternsOnText#Transactional#ExprEach#SortByPosition'), [[s:b, s:c, -1, 0], [s:b, s:c, -1, 1], [s:b, s:c, -1, 2]], 'identical positions, different patternIndices sorted from low to high')
call vimtap#Is(sort([[s:a, s:b, -1, 2], [s:b, s:c, -1, 1], [s:b, s:c, -1, 0], [s:c, s:d, -1, 0]], 'PatternsOnText#Transactional#ExprEach#SortByPosition'), [[s:c, s:d, -1, 0], [s:b, s:c, -1, 0], [s:b, s:c, -1, 1], [s:a, s:b, -1, 2]], 'earlier position takes precedence over patternIndices')

call vimtest#Quit()
