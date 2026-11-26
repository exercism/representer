type dna =
  | A
  | C
  | G
  | T;

type rna =
  | A
  | C
  | G
  | U;

let convertNucleotide = (x: dna) => 
    switch (x) {
    | G => C
    | C => G
    | T => A
    | A => U
    }

let toRna = (dna: list(dna)) =>
  List.map(convertNucleotide, dna)