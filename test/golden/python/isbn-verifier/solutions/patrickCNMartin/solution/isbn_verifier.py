import pdb
def is_valid(isbn):
    code = []
    for idx, item in enumerate(isbn):
        if item.isdigit():
            code.append(int(item))
        if item == "X" and idx +1 == len(isbn):
            code.append(10)
        if item.isalpha() and item != "X":
            return False
    
    if len(code) >10:
        return False
    elif len(code) <10:
        return False
    valid = []
    multiplier = [m for m in reversed(range(1,11))]
    for i in range(len(code)):
        valid.append(code[i] * multiplier[i])

    return sum(valid) % 11 ==0
