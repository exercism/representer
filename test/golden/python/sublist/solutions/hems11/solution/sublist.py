SUBLIST = 1
SUPERLIST = 2
EQUAL = 3
UNEQUAL = 0

def sublist(list_one, list_two):
    if list_one == list_two:
        return 3
    elif is_sublist(list_one, list_two):
        return 2
    elif is_sublist(list_two, list_one):
        return 1
    return 0
    
def is_sublist(one, two):
    for i in range(len(one) - len(two) + 1):
        if not two or two == one[i : i + len(two)]:
            return True
    return False