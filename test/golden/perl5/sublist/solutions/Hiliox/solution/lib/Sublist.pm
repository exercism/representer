package Sublist;

use v5.40;
use Data::Dump qw(dump);

use Exporter qw<import>;
our @EXPORT_OK = qw<compare_lists>;

sub compare_lists ( $list1, $list2 ) {
    my $list1Len = scalar @$list1;
    my $list2Len = scalar @$list2;
    if ($list1Len == $list2Len) {
        return _isEqual($list1, $list2);
    } elsif ($list1Len > $list2Len) {
        return "superlist" if (_isSublist($list2, $list1));
        return "unequal";
    } elsif ($list1Len < $list2Len) {
        return "sublist" if (_isSublist($list1, $list2));
        return "unequal";
    }
}

sub _isSublist($small, $large) {
    my $smallLen = scalar @$small;
    my $largeLen = scalar @$large;
    for (my $i=0; $i<=($largeLen - $smallLen); $i++) {
        my @slice = @$large[$i .. $i+$smallLen-1];
        say "small: " . dump(@$small);
        say "slice: " . dump(@slice);
        if (_isEqual($small, \@slice) eq "equal") {
            return 1;
        }
    }
    return 0;
}

sub _isEqual($list1, $list2) {
    for (my $i=0; $i<scalar @$list1; $i++) {
        if ($list1->[$i] ne $list2->[$i]) {
            return "unequal";
        }
    }
    return "equal";
}

1;
