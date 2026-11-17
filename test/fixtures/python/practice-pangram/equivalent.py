from string import ascii_lowercase

def placeholder_0(placeholder_1):
    return all((placeholder_2 in placeholder_1.lower() for placeholder_2 in ascii_lowercase))
