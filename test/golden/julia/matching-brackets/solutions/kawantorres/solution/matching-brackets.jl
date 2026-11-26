
function matching_brackets(input_string::String)::Bool

    openBracket = 0;
    openBrace = 0;
    openParentheses = 0;
    lastLetter = 0;
    stack_letters = Array{Char}(undef,0)
    input_dictionaries = ['[','{','(']
    output_dictionaries = [']','}',')']
    for letter in input_string
        if !isnothing(indexin(letter,input_dictionaries)[1])
            push!(stack_letters,letter)
        end
        if !isnothing(indexin(letter,output_dictionaries)[1])
            if !isempty(stack_letters)
                letter_in_stack = pop!(stack_letters)
            else
                letter_in_stack = 's'
            end
            if indexin(letter_in_stack, input_dictionaries)[1] != indexin(letter, output_dictionaries)[1]
                return false
            end
        end
    end

    isempty(stack_letters)

end