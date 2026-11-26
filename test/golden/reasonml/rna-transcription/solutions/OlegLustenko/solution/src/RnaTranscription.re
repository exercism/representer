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

let toRna = dna =>
  List.map(
    (dnaItem: dna) =>
      switch (dnaItem) {
      | G => C
      | C => G
      | T => A
      | A => U
      },
    dna,
  );