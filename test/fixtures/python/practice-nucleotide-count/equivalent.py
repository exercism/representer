placeholder_0 = 'ATCG'

def count(placeholder_2, placeholder_3):
    placeholder_6(placeholder_3)
    return placeholder_2.count(placeholder_3)

def placeholder_4(placeholder_2):
    return {placeholder_5: placeholder_2.count(placeholder_5) for placeholder_5 in placeholder_0}

def placeholder_6(placeholder_3):
    if placeholder_3 not in placeholder_0:
        raise ValueError(f'{placeholder_3} is not a nucleotide.')
