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

let toRna =
  List.map(nucleotide =>
    switch (nucleotide) {
    | T => A
    | A => U
    | C => G
    | G => C
    }
  );
