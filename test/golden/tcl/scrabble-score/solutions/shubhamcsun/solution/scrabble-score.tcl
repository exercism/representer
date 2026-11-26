proc letterScore {letter} {
    switch -regexp $letter {
        [AEIOULNRST] {expr {1}}
        [DG]         {expr {2}}
        [BCMP]       {expr {3}}
        [FHVWY]      {expr {4}}
        [K]          {expr {5}}
        [JX]         {expr {8}}
        [QZ]         {expr {10}}
        default      {expr {0}}
    }
}

proc scrabbleScore {word} {
    variable score 0

    foreach c [split [string toupper $word] ""] {
        incr score [letterScore $c]
    }

    return $score
}