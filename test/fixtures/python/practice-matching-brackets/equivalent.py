def placeholder_0(placeholder_1):
    placeholder_2 = {')': '(', '}': '{', ']': '['}
    placeholder_3 = []
    for placeholder_4 in placeholder_1:
        if placeholder_4 in placeholder_2.values():
            placeholder_3.append(placeholder_4)
        elif placeholder_4 in placeholder_2:
            if not placeholder_3:
                return False
            if placeholder_3.pop() != placeholder_2[placeholder_4]:
                return False
    return not placeholder_3
