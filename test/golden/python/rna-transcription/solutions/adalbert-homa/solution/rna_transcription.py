map = {'G':'C', 'C':'G', 'T':'A', 'A':'U'}
def to_rna(dna_strand):
    return ''.join([map[c] for c in dna_strand])
