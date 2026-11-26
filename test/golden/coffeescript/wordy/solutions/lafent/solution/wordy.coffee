class WordProblem
    constructor: (@problem) ->
        @ERROR = { tooComplicated: "Unable to perform operation" }
        @tokens = @problem.split(' ')

    answer:() ->
        throw @ERROR.tooComplicated if @tokens.shift() != 'What'
        throw @ERROR.tooComplicated if @tokens.shift() != 'is'

        answer = parseInt @tokens.shift()
        
        while @tokens.length > 0
            el = @tokens.shift()
            if el == 'plus'
                answer += parseInt @tokens.shift()
            else if el == 'minus'
                answer -= parseInt @tokens.shift()
            else if el == 'multiplied'
                @tokens.shift()
                answer *= parseInt @tokens.shift()
            else if el == 'divided'
                @tokens.shift()
                answer /= parseInt @tokens.shift()
            else
                throw @ERROR.tooComplicated

        return answer

module?.exports = WordProblem