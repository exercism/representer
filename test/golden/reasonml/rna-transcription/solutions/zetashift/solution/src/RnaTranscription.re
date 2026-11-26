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

/* translate each nucleotide*/
let switcheroo = (nucl: dna) =>
  switch (nucl) {
  | A => U
  | C => G
  | G => C
  | T => A
  };

let toRna = dnaList => {
    List.map(switcheroo, dnaList)
}