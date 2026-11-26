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

let rnaTable = (code:dna) => {
    switch (code) {
    | A => U
    | C => G
    | G => C
    | T => A
    };
};

let toRna = (d) => {
  d |> List.map(rnaTable);
};
