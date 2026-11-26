
// This code is actually from someone else.  I studied and found my mistake and love their approach
//  My mistake was a mis reading of the readme file.  Oversight by being blind
const CODONS: { [codon: string]: string } = {
  AUG: "Methionine",
  UUU: "Phenylalanine", UUC: "Phenylalanine",
  UUA: "Leucine", UUG: "Leucine",
  UCU: "Serine", UCC: "Serine", UCA: "Serine", UCG: "Serine",
  UAU: "Tyrosine", UAC: "Tyrosine",
  UGU: "Cysteine", UGC: "Cysteine",
  UGG: "Tryptophan",
  UAA: "STOP", UAG: "STOP", UGA: "STOP",
}

export const translate = (rna: string = ""): string[] => {
  const rnaSeq: string[] = rna.match (/.../g) ?? []
  const proteins: string[] = rnaSeq.map (codon => CODONS[codon] ?? 'INVALID')
  const stop: number = proteins.indexOf("STOP")
  if ( proteins.includes('INVALID') || (rna.length % 3 && stop < 0) ) {  
    throw new Error('Invalid codon') 
  }
  return stop > -1 ? proteins.slice(0, stop) : proteins
}
