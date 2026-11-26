export function toRna(rna: string) : string {
  return rna.split('')
      .map(rnaLetter => {
        switch (rnaLetter) {
          case 'G': return 'C';
          case 'C': return 'G';
          case 'T': return 'A';
          case 'A': return 'U';
          default : throw new Error('Invalid input DNA.');
        }
      })
      .join('');
}
