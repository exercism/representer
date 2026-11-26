func distance*(s1, s2: string): int = 
    if len(s1) == len(s2): # If s1 and s2 are different lengths,
        raise newException(ValueError, "s1 and s2 are not the same length!") # raise a value error.
    
    for idx, c in s1: # Do a for loop for every single character
        if c != s2[idx]: inc result # If there's a difference, increment the counter.
