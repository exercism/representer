module ScrabbleScore

(*
A, E, I, O, U, L, N, R, S, T       1
D, G                               2
B, C, M, P                         3
F, H, V, W, Y                      4
K                                  5
J, X                               8
Q, Z                               10
*)
let letterScores = Map [
    ('a', 1); ('e', 1); ('i', 1); ('o', 1); ('u', 1); ('l', 1)
    ('n', 1); ('r', 1); ('s', 1); ('t', 1); 
    ('d', 2); ('g', 2);
    ('b', 3); ('c', 3); ('m', 3); ('p', 3);
    ('f', 4); ('h', 4); ('v', 4); ('w', 4); ('y', 4);
    ('k', 5);
    ('j', 8); ('x', 8);
    ('q', 10); ('z', 10);
]

let score (word: string) = 
    word.ToLower()
    |> Seq.fold (fun acc c -> acc + Map.find c letterScores) 0

// Extension to build a scrabble score with multipliers.
// The word multiplier is applied once the score for the word
// has been calculated. 
// For the letterMultipliers I have assumed a sequence of multipliers
// (with 1 being the standard). This is the easiest to process.
// As an alternative one could use a map structure only containing the 
// position of the letters having a multiplier different from 1. This
// would make the processing more difficult but have a better memory
// efficiency.
let scoreWithMultipliers (word: string) letterMultipliers wordMultiplier =
    if String.length word <> Seq.length letterMultipliers then
        failwith "list of letter multipliers must match length of word"
    else 
        word.ToLower()
        |> Seq.fold2 (fun acc mult c -> acc + Map.find c letterScores * mult) 0 letterMultipliers
        |> (*) wordMultiplier