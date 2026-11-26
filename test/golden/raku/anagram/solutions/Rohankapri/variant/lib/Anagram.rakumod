sub match-anagrams ( :$subject!, :@candidates! ) is export {
    @candidates.grep: {
        my @words = ($_, $subject)>>.fc;
        [ne] @words or [eqv] @words.map(*.comb.sort)
    }
}