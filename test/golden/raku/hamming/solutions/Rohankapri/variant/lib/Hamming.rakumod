sub hamming-distance ( *@strands ) is export {
    fail "strands must be pf equal length" unless [==] @strands».chars;
    sum [Zne] @strands».comb
}