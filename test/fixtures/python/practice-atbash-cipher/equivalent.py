from string import ascii_lowercase
placeholder_0 = 5
placeholder_1 = str.maketrans(ascii_lowercase, ascii_lowercase[::-1])

def placeholder_2(placeholder_3):
    return ''.join([placeholder_4 for placeholder_4 in placeholder_3 if placeholder_4.isalnum()]).lower().translate(placeholder_1)

def encode(placeholder_6):
    placeholder_7 = placeholder_2(placeholder_6)
    return ' '.join((placeholder_7[placeholder_8:placeholder_8 + placeholder_0] for placeholder_8 in range(0, len(placeholder_7), placeholder_0)))

def decode(placeholder_10):
    return placeholder_2(placeholder_10)
