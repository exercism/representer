unit module Isogram;

sub is-isogram($text) is export {
    # Empty string is considered an isogram
    return True if $text eq "";
    
    # Convert to lowercase and remove spaces and hyphens
    my $normalized = $text.lc.subst(/[\s|\-]/, "", :g);
    
    # Create a set from the characters to remove duplicates
    my $unique-chars = $normalized.comb.Set;
    
    # If the number of unique characters equals the length of the normalized string,
    # then there are no duplicates (it's an isogram)
    return $unique-chars.elems == $normalized.chars;
}