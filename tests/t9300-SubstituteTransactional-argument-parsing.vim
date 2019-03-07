" Test parsing of :SubstituteTransactional arguments

function! s:Parse( arguments ) abort
    return PatternsOnText#Transactional#ParseArguments('PP', 'PR', 'PF', 't/PT/u/PU/', a:arguments)
endfunction

call vimtest#StartTap()
call vimtap#Plan(18)

call vimtap#Is(s:Parse('/foo/bar/gcit/test/u/update/'), ['/', 'foo', 'bar', 'gci', 't/test/u/update/', 'test', 'update'], 'full arguments without spaces')
call vimtap#Is(s:Parse('/foo/bar/gci t/test/ u/update/'), ['/', 'foo', 'bar', 'gci', ' t/test/ u/update/', 'test', 'update'], 'full arguments special flags separated by spaces')
call vimtap#Is(s:Parse('!foo!bar!gcit#test#u@update@'), ['!', 'foo', 'bar', 'gci', 't#test#u@update@', 'test', 'update'], 'full arguments all with different separators')
call vimtap#Is(s:Parse('/f o o/ bar /gcit/t e s t/u/ update /'), ['/', 'f o o', ' bar ', 'gci', 't/t e s t/u/ update /', 't e s t', ' update '], 'full arguments with spaces')

call vimtap#Is(s:Parse('/foo/bar/gciu/update/t/test/'), ['/', 'foo', 'bar', 'gci', 'u/update/t/test/', 'test', 'update'], 'full arguments different order of special flags')
call vimtap#Is(s:Parse('/foo/bar/gciu/update/'), ['/', 'foo', 'bar', 'gci', 'u/update/', '', 'update'], 'missing test flag')
call vimtap#Is(s:Parse('/foo/bar/gcit/test/'), ['/', 'foo', 'bar', 'gci', 't/test/', 'test', ''], 'missing update flag')
call vimtap#Is(s:Parse('/foo/bar/gci'), ['/', 'foo', 'bar', 'gci', '', '', ''], 'no special flags')
call vimtap#Is(s:Parse('/foo/bar/t/test/u/update/'), ['/', 'foo', 'bar', '', 't/test/u/update/', 'test', 'update'], 'no default flags')

call vimtap#Is(s:Parse('/foo/bar/'), ['/', 'foo', 'bar', '', '', '', ''], 'just pattern and replacement')
call vimtap#Is(s:Parse('/foo/'), ['/', 'foo', 'PR', '', '', '', ''], 'just pattern')
call vimtap#Is(s:Parse('//'), ['/', 'PP', 'PR', '', '', '', ''], 'empty pattern')
call vimtap#Is(s:Parse('///'), ['/', 'PP', '', '', '', '', ''], 'empty pattern and replacement')
call vimtap#Is(s:Parse('///ge'), ['/', 'PP', '', 'ge', '', '', ''], 'empty pattern and replacement with default flags')

call vimtap#Is(s:Parse(''), ['/', 'PP', 'PR', 'PF', 't/PT/u/PU/', 'PT', 'PU'], 'empty arguments')
call vimtap#Is(s:Parse('Ic'), ['/', 'PP', 'PR', 'Ic', 't/PT/u/PU/', 'PT', 'PU'], 'just default flags')
call vimtap#Is(s:Parse('t/test/'), ['/', 'PP', 'PR', 'PF', 't/test/', 'test', ''], 'just test flag')
call vimtap#Is(s:Parse('cIt/test/u/update/'), ['/', 'PP', 'PR', 'cI', 't/test/u/update/', 'test', 'update'], 'default and special flags')

call vimtest#Quit()
