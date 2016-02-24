" Test parsing of the selection answers.

call vimtest#StartTap()
call vimtap#Plan(29)

function! AssertException( answers, expected, ... )
    try
	call PatternsOnText#Selected#CreateAnswers(a:answers)
	call vimtap#Fail('expected exception on ' . string(a:answers))
    catch
	call vimtap#err#Thrown(a:expected, (a:0 ? a:1 : a:expected))
    endtry
endfunction

function! AssertAnswers( answers, expected, description )
    let l:answerObject = PatternsOnText#Selected#CreateAnswers(a:answers)
    let l:answers = map(range(1, len(a:expected)), 'PatternsOnText#Selected#GetAnswer(l:answerObject, v:val)')
    call vimtap#Is(l:answers, a:expected, a:description)
endfunction

call AssertAnswers('', [0, 0, 0], 'no answers')
call AssertAnswers('y', [1, 1, 1], 'repeat of y')
call AssertAnswers('n', [0, 0, 0], 'repeat of n')
call AssertAnswers('yn', [1, 0, 1, 0], 'repeat of yn')
call AssertAnswers('nyn', [0, 1, 0, 0, 1, 0], 'repeat of nyn')
call AssertAnswers('yynnyn', [1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0], 'repeat of yynnyn')

call AssertAnswers('2y2ny1n', [1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0], 'repeat of 2y2ny1n')
call AssertAnswers('3y2n', [1, 1, 1, 0, 0, 1], 'repeat of 3y2n')
call AssertAnswers('y0ny', [1, 1, 1], 'repeat of y0ny')

call AssertAnswers('1', [1, 0, 0], 'position 1')
call AssertAnswers('3', [0, 0, 1, 0], 'position 3')
call AssertAnswers('10,12', [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0], 'positions 10,12')
call AssertAnswers('1,3', [1, 0, 1, 0], 'positions 1,3')
call AssertAnswers('1,3,4', [1, 0, 1, 1, 0, 0], 'positions 1,3,4')
call AssertAnswers('1,3-4', [1, 0, 1, 1, 0, 0], 'positions 1,3-4')
call AssertAnswers('2-4', [0, 1, 1, 1, 0, 0], 'positions 2-4')
call AssertAnswers('-4', [1, 1, 1, 1, 0, 0], 'positions -4')
call AssertAnswers('4-', [0, 0, 0, 1, 1, 1, 1, 1, 1], 'positions 4-')
call AssertException('3,4,2', 'PatternsOnText: Preceding position 2 after position 4', 'wrong position order')
call AssertException('3,4,1-2', 'PatternsOnText: Preceding position 1-2 after position 4', 'wrong position order')
call AssertException('0', 'PatternsOnText: Invalid position "0"')
call AssertException('4-,10', 'PatternsOnText: Preceding position 10 after position 999', 'position after open-ended range')

call AssertAnswers('yn5', [1, 0, 0, 0, 1, 0, 0], 'mixed positions yn5')
call AssertAnswers('yn,5,6', [1, 0, 0, 0, 1, 1, 0], 'mixed positions yn,5,6')
call AssertAnswers('3,n2y', [0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1], 'repeat of mixed positions 3,n2y')

call AssertException('abc', 'PatternsOnText: Invalid position "abc"')
call AssertException('3-5-8', 'PatternsOnText: Invalid position "3-5-8"')
call AssertException('1-3yn', 'PatternsOnText: Invalid position "1-3y"')
call AssertException('5-3', 'PatternsOnText: Invalid position range "5-3"')

call vimtest#Quit()
