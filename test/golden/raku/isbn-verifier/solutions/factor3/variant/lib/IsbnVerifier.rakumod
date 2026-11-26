unit module IsbnVerifier;

sub is-isbn10 is export {
    my $digits = $^s.subst: '-', '', :g;
    return False unless $digits ~~ /^\d**9<[\dX]>$/;
    my @digits = $digits.comb;
    my $last = @digits.tail;
    @digits[*+1] = $last eq 'X' ?? 10 !! $last;
    11 R%% [+] (10...1) Z* @digits
}