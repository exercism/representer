ALPHABET = "abcdefghijklmnopqrstuvwxyz"


def rotate(text: str, key: int) -> str:
    if key == 0 or key == 26:
        return text
    rot_alphabet = "".join([(ALPHABET[index + key]) if len(ALPHABET) > index +
                            key else ALPHABET[index+key - len(ALPHABET)] for index in range(len(ALPHABET))])
    rot_table = str.maketrans(ALPHABET, rot_alphabet) | str.maketrans(
        ALPHABET.upper(), rot_alphabet.upper())

    return text.translate(rot_table)
