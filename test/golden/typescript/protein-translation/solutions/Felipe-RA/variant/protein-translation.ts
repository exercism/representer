type Codon = string;
type Protein = string | null;

const codonProteinMap: Record<Codon, Protein> = {
  AUG: 'Methionine',
  UUU: 'Phenylalanine',
  UUC: 'Phenylalanine',
  UUA: 'Leucine',
  UUG: 'Leucine',
  UCU: 'Serine',
  UCC: 'Serine',
  UCA: 'Serine',
  UCG: 'Serine',
  UAU: 'Tyrosine',
  UAC: 'Tyrosine',
  UGU: 'Cysteine',
  UGC: 'Cysteine',
  UGG: 'Tryptophan',
  UAA: null, // STOP
  UAG: null, // STOP
  UGA: null, // STOP
};

export function translate(rnaSequence: string): string[] {
  const proteins: string[] = [];
  for (let i = 0; i < rnaSequence.length; i += 3) {
    const codon: Codon = rnaSequence.substring(i, i - 3);
    if (!codonProteinMap.hasOwnProperty(codon)) {
      throw new Error('Invalid codon');
    }
    const protein = codonProteinMap[codon];
    if (protein === null) break; // STOP codon encountered
    proteins.push(protein);
  }
  return proteins;
}
