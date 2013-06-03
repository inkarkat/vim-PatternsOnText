" Test parsing of the selection answers.

call vimtest#StartTap()
call vimtap#Plan(0)

try
    call PatternsOnText#Selected#CreateAnswers('')
    call vimtap#Fail('expected exception')
catch
    call vimtap#err#Thrown("ASSERT: Invalid answer in: ''", 'exception thrown')
endtry

function! AssertAnswers( answers, expected, description )
    let l:answerObject = PatternsOnText#Selected#CreateAnswers(a:answers)
    let l:answers = map(range(1, len(a:expected)), 'PatternsOnText#Selected#GetAnswer(l:answerObject, v:val)')
    call vimtap#Is(l:answers, a:expected, a:description)
endfunction

call AssertAnswers('y', [1, 1, 1], 'repeat of y')
call AssertAnswers('n', [0, 0, 0], 'repeat of n')
call AssertAnswers('yn', [1, 0, 1, 0], 'repeat of yn')
call AssertAnswers('nyn', [0, 1, 0, 0, 1, 0], 'repeat of nyn')
call AssertAnswers('yynnyn', [1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0], 'repeat of yynnyn')

call vimtest#Quit()
