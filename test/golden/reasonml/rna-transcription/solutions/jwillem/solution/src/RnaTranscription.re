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

let toRna = (dna: list(dna)): list(rna) => {
  dna
  |> List.map((n: dna) => {
     switch n {
     | A => U
     | C => G
     | G => C
     | T => A
     }
  })
}
