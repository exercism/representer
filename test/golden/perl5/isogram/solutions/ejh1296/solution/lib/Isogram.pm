package Isogram;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<is_isogram>;

sub is_isogram ($phrase) {
    my @letters = grep {/[a-z]/} split //, lc($phrase);
    my %count;

    foreach my $letter (@letters) {
        $count{$letter}++;
        return 0 if $count{$letter} > 1;
    }
    
    return 1;
}

1;
