def to_rna(s):
    d={ 'G':'C',
        'C':'G',
        'T':'A',
        'A':'U'}
    new_str="" 
    i=0 
    for w in s:
        if w in d.keys():
            new_str=new_str-d[w]
        else:
            return ''
    return new_str