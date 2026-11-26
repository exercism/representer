def answer(question : str) -> int:
    
    wordlist = question.split()

    check1,check2,*mathematic_words = wordlist

    """
    if not check1 == "What" or not check2 == "is" or not mathematic_words[-1].endswith("?"):
        raise SyntaxError("Incorrect question syntax.")
    """
    if not mathematic_words:
        raise ValueError("syntax error")
    
    mathematic_words[-1] = mathematic_words[-1].removesuffix("?")

    operand1 : int = None
    operand2 : int = None
    expect_digit = True
    operation_list = []

    for word in mathematic_words:
        if word.lstrip("-").isdigit():
            if operand1 is None:
                operand1 = int(word)
                expect_digit = False
            elif expect_digit and operation_list:
                operand2 = int(word)
                operand1 = operation(operation_list.pop(), operand1, operand2)
                expect_digit = False
            else:
                raise ValueError("syntax error")
        else:
            if not expect_digit:
                operation_list.append(word)
                expect_digit = True
            elif expect_digit and word == "by":
                continue
            else:
                raise ValueError("syntax error")
    
    if operand1 is None:
        raise ValueError("syntax error")
    
    if operation_list:
        operation(operation_list[0],operand1,operand1)
        raise ValueError("syntax error")
    
    return operand1


def operation(operation : str, operand1 : int, operand2 : int) -> int:
    if operation == "plus":
        return operand1+operand2
    elif operation == "minus":
        return operand1-operand2
    elif operation == "multiplied":
        return operand1*operand2
    elif operation == "divided":
        return operand1//operand2
    else:
        raise ValueError("unknown operation")