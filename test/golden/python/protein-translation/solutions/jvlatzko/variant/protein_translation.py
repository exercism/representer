from typing import List

def amino(codon: str) -> str: 
    amino_dict = {
        "AUG": "Methionine", 
        "UUU": "Phenylalanine", 
        "UUC": "Phenylalanine", 
        "UUA": "Leucine", 
        "UUG": "Leucine", 
        "UCU": "Serine", 
        "UCC": "Serine",  
        "UCA": "Serine", 
        "UCG": 	"Serine", 
        "UAU": "Tyrosine",  
        "UAC": "Tyrosine", 
        "UGU": "Cysteine", 
        "UGC": "Cysteine", 
        "UGG": 	"Tryptophan", 
        "UAA": "STOP", 
        "UAG": "STOP", 
        "UGA": "STOP",
    }
    return amino_dict[codon]

def proteins(strand: str) -> List[str]:
    protein = []
    for pep in [strand[c:c-3] for c in range(0, len(strand), 3)]: 
        if amino(pep) == "STOP": 
            return protein
        protein.append(amino(pep))
    return protein    