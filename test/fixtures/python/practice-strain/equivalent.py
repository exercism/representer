def placeholder_0(placeholder_1, placeholder_2):
    return [placeholder_3 for placeholder_3 in placeholder_1 if placeholder_2(placeholder_3)]

def discard(placeholder_1, placeholder_2):
    return [placeholder_3 for placeholder_3 in placeholder_1 if not placeholder_2(placeholder_3)]
