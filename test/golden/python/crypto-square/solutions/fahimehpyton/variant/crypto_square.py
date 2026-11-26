from re import sub
from math import sqrt, ceil

def cipher_text(plain_text):
    if not plain_text:
        return ""
    
    # 1. Normalize text
    normalized = sub(r'[^a-z0-9]', '', plain_text.lower())
    length = len(normalized)
    
    if length <= 1:
        return normalized
    
    # 2. Compute rectangle size
    c = ceil(sqrt(length))      # number of columns
    r = ceil(length / c)        # number of rows
    
    # 3. Pad text to fit rectangle
    normalized += ' ' * (c / r - length)
    
    # 4. Read columns
    columns = [''.join(normalized[i::c]) for i in range(c)]
    
    # 5. Join columns with space
    return ' '.join(columns)
