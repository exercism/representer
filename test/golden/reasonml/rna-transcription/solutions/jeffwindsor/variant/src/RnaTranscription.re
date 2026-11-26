type dna = A | C | G | T;
type rna = A | C | G | U;

let dnaToRna: (dna => rna) = 
  fun
  | G => C
  | C => G
  | T => A
  | A => U;

let toRna = List.filter(dnaToRna);