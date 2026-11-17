def placeholder_0(placeholder_1):
    return sum(sorted(placeholder_1)[:2]) >= sorted(placeholder_1)[2] and all((placeholder_2 > 0 for placeholder_2 in placeholder_1))

def placeholder_3(placeholder_1):
    return placeholder_0(placeholder_1) and all((placeholder_1[0] == placeholder_2 for placeholder_2 in placeholder_1))

def placeholder_4(placeholder_1):
    return placeholder_0(placeholder_1) and any((placeholder_5 == placeholder_6 for placeholder_5, placeholder_6 in zip(sorted(placeholder_1), sorted(placeholder_1)[1:])))

def placeholder_7(placeholder_1):
    return placeholder_0(placeholder_1) and (not placeholder_4(placeholder_1))
