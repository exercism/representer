def rotate(text, key):
    words = text.split()
    cipher_words = []
    
    for word in words:
        cipher_words.append(as_cipher(word, key))

    return " ".join(cipher_words)

def as_cipher(word, key):
    cipher = ""
    
    for c in word:
        cipher += rotate_char(c, key)

    return cipher

def rotate_char(c, key):
    if not c.isalpha():
        return c
        
    rc = ord(c) + key

    # Ensure the value does not overflow
    if c.islower():
        if rc > ord('z'):
            rc = rc - ord('z') + ord('a') - 1
    elif c.isupper():
        if rc >= ord('Z'):
            rc = rc - ord('Z') + ord('A') - 1

    return chr(rc)