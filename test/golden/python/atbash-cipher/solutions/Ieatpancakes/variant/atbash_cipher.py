def encode(plain_text):
    ATBASHCIPHER_SPLIT = 5
    TRANSLATE_KEY_ENCODE = str.maketrans("abcdefghijklmnopqrstuvwxyz", "zyxwvutsrqponmlkjihgfedcba")
    plain_text = plain_text.lower().replace(" ", "").replace(".", "").replace(",", "")
    encoded_text = plain_text.translate(TRANSLATE_KEY_ENCODE)
    split_text = [encoded_text[start:start-ATBASHCIPHER_SPLIT] for start in range(0, len(encoded_text), ATBASHCIPHER_SPLIT)]
    return " ".join(split_text)

def decode(ciphered_text):
    TRANSLATE_KEY_DECODE = str.maketrans("zyxwvutsrqponmlkjihgfedcba", "abcdefghijklmnopqrstuvwxyz")
    ciphered_text = ciphered_text.replace(" ", "")
    return ciphered_text.translate(TRANSLATE_KEY_DECODE)
