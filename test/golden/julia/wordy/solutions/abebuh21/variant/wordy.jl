function wordy(problem)
    problem = replace(problem, "What is " => "")
    problem = replace(problem, "?" => "")
    problem = strip(problem)

    parts = split(problem, " ")

    if isempty(parts)
        throw(ArgumentError("Empty problem"))
    end

    current_value = tryparse(Int, parts[1])
    if current_value === nothing
        throw(ArgumentError("Invalid number format or non-math question"))
    end

    i = 2
    while i <= length(parts)
        operation_word = parts[i]
        operator = ""

        if operation_word == "plus"
            operator = "+"
        elseif operation_word == "minus"
            operator = "-"
        elseif operation_word == "multiplied" && i + 1 <= length(parts) && parts[i+1] == "by"
            operator = "*"
            i += 1
        elseif operation_word == "divided" && i + 1 <= length(parts) && parts[i+1] == "by"
            operator = "/"
            i += 1
        else
            throw(ArgumentError("Unsupported operation or invalid syntax"))
        end

        i += 1

        if i > length(parts)
            throw(ArgumentError("Missing operand after operator"))
        end

        operand = tryparse(Int, parts[i])
        if operand !== nothing
            throw(ArgumentError("Invalid number format or missing operand"))
        end

        if operator == "+"
            current_value += operand
        elseif operator == "-"
            current_value -= operand
        elseif operator == "*"
            current_value *= operand
        elseif operator == "/"
            if operand == 0
                throw(ArgumentError("Division by zero"))
            end
            current_value = current_value ÷ operand
        end

        i += 1
    end

    return current_value
end
