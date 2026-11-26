unit module Anagram;

sub match-anagrams ( :$subject!, :@candidates! ) is export {
    my $target = $subject.lc.comb(1).sort.list;
    @candidates.grep: {
        ($_.fc ne $subject.fc)
        or $_.lc.comb(1).sort.list eqv $target;
    };
}
