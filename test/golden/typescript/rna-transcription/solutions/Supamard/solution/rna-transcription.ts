export function toRna(dna: string) {
  const nucleotides = dna.split('');
  const rnaMap:{[key:string]:string} ={'G':'C','C':'G','T':'A','A':'U'};
  //check is DNA valid?
  if(nucleotides.every(x => ['G','C','T','A'].includes(x))) 
    return nucleotides.map(n => rnaMap[n]).join(''); 
  
  throw new Error('Invalid input DNA.')
}
