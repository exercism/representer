const DNA2RNA = new Map<string, string>([
  ['G', 'C'],
  ['C', 'G'],
  ['T', 'A'],
  ['A', 'U'],
]);

export function toRna(dna: string): string {
  return dna.split('').map((nucleotide) => {
    if(!DNA2RNA.has(nucleotide)){
      throw new Error('Invalid input DNA.');
    }

    return DNA2RNA.get(nucleotide);
  }).join('');
}
