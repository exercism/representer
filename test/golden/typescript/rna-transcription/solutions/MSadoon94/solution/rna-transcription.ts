const nucleotides = new Map<string, string>([
  ["C", "G"],
  ["G", "C"],
  ["A", "U"],
  ["T", "A"]
]
)
export function toRna(dna: string): string {
  let rna = ""
  for(let i = 0; i < dna.length; i++){
    if(nucleotides.has(dna[i])){
      rna += nucleotides.get(dna[i]);
    } else {
      throw new Error("Invalid input DNA.");
    }
  }
  return rna;
}
