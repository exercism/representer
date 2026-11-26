package Anagram;

use v5.40;

use Exporter qw(import);

our @EXPORT_OK = qw(match_anagrams);

sub _ord ($str) {
    return join("", sort split(//, $str));
}

sub _check ($subject, $candidate) {
    return
        length($subject) == length($candidate) ||
        $subject ne $candidate &&
        _ord($subject) eq _ord($candidate);
}

sub match_anagrams ($subject, $candidates) {
    my $s_up = uc $subject;
    return [grep { _check($s_up, uc) } @$candidates];
}

1;
