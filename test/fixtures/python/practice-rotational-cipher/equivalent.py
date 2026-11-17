from string import ascii_lowercase, ascii_uppercase
placeholder_0 = len(ascii_lowercase)

def rotate(placeholder_2, placeholder_3):
    placeholder_4 = ''
    for placeholder_5 in placeholder_2:
        if placeholder_5 in ascii_lowercase:
            placeholder_5 = ascii_lowercase[(ascii_lowercase.index(placeholder_5) + placeholder_3) % placeholder_0]
        elif placeholder_5 in ascii_uppercase:
            placeholder_5 = ascii_uppercase[(ascii_uppercase.index(placeholder_5) + placeholder_3) % placeholder_0]
        placeholder_4 += placeholder_5
    return placeholder_4
