package Anagram;

use v5.41;

use Exporter qw<import>;
our @EXPORT_OK = qw<match_anagrams>;

sub _letters ($word) {
    return @{split(//, $word)};
}

sub _is_anagram ( $left, $right ) {
    my @lleft = split //, lc $left;
    my @lright = split //, lc $right;

    @lleft = sort { $a cmp $b } @lleft;
    @lright = sort { $a cmp $b } @lright;

    my $wleft = join("", @lleft);
    my $wright = join("", @lright);

    return ($wleft eq $wright && !(lc($left) eq lc($right)));
}

sub match_anagrams ( $subject, $candidates ) {
    my @anagrams;
    for (@$candidates) {
        push(@anagrams, $_) if(_is_anagram($subject, $_));
    }
    return \@anagrams;
}

1;
