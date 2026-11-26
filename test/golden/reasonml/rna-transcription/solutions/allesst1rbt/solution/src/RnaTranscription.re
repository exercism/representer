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
let transform = (x:dna) => switch x {
| A =>  U
| C =>  G
| G =>  C
| T =>  A
};
let toRna = (x:list(dna))  => List.map(y=>y|>transform ,x) ;

