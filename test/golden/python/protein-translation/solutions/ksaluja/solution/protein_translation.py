

def proteins(strand):
    proteins = {'AUG': 'Methionine',
'UUU': 'Phenylalanine', 
'UUC': 'Phenylalanine',
'UUA':'Leucine', 
'UUG':'Leucine',
'UCU':'Serine', 
'UCC':'Serine', 
'UCA':'Serine', 
'UCG':'Serine',
'UAU':'Tyrosine', 
'UAC': 'Tyrosine',
'UGU' :'Cysteine', 
'UGC': 'Cysteine',
'UGG': 'Tryptophan'}
    STOP_LIST = ['UAA', 'UAG', 'UGA']
    protein_list = []
    # put these in a list of lists
    for i in range(0, len(strand), 3):
        codon = strand[i:i+3]
        print(codon)
        if codon not in STOP_LIST:
            protein_list.append((proteins[codon]))
        else:
            return protein_list
    return  protein_list
