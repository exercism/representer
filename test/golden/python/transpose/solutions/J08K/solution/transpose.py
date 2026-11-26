import itertools

def transpose(text):
    a = itertools.zip_longest(*text.splitlines(), fillvalue='$')
    return '\n'.join(''.join(w).rstrip('$').replace('$', ' ') for w in a)