proc toRna*(dna: string): string =
    for n in dna:
        case n:
        of 'G':
            result.add('C')
        of 'C':
            result.add('G')
        of 'T':
            result.add('A')
        of 'A':
            result.add('U')
        else: raise newException(ValueError, "invalid nvcleotide")