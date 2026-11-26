open Belt;

let explode = s => List.makeBy(String.length(s), String.get(s));

let rec chunks = (xs, n) =>
  switch (xs) {
  | [] => []
  | xs =>
    switch (List.splitAt(xs, n)) {
    | Some((us, vs)) => [us, ...chunks(vs, n)]
    | None => [xs]
    }
  };

let proteins = sequence => {
  let rec translate = acc =>
    fun
    /* empty or stop codons */
    | []
    | [['U', 'A', 'A'], ..._]
    | [['U', 'A', 'G'], ..._]
    | [['U', 'G', 'A'], ..._] => List.reverse(acc)
    | [['A', 'U', 'G'], ...codons] =>
      translate(["Methionine", ...acc], codons)
    | [['U', 'U', 'U'], ...codons]
    | [['U', 'U', 'C'], ...codons] =>
      translate(["Phenylalanine", ...acc], codons)
    | [['U', 'U', 'A'], ...codons]
    | [['U', 'U', 'G'], ...codons] =>
      translate(["Leucine", ...acc], codons)
    | [['U', 'C', 'U'], ...codons]
    | [['U', 'C', 'C'], ...codons]
    | [['U', 'C', 'A'], ...codons]
    | [['U', 'C', 'G'], ...codons] => translate(["Serine", ...acc], codons)
    | [['U', 'A', 'U'], ...codons]
    | [['U', 'A', 'C'], ...codons] =>
      translate(["Tyrosine", ...acc], codons)
    | [['U', 'G', 'U'], ...codons]
    | [['U', 'G', 'C'], ...codons] =>
      translate(["Cysteine", ...acc], codons)
    | [['U', 'G', 'G'], ...codons] =>
      translate(["Tryptophan", ...acc], codons)
    /* invalid codons */
    | _ => [];

  sequence->explode->chunks(4)->translate([], _);
};
