package Allergies;

use v5.38;

use Exporter qw<import>;
our @EXPORT_OK = qw<allergic_to list_allergies>;

my %list = (eggs => 0, 
            peanuts => 1, 
            shellfish => 2, 
            strawberries => 3, 
            tomatoes => 4, 
            chocolate => 5, 
            pollen => 6, 
            cats => 7);

sub allergic_to ( $item, $score ) {
    my @bin = reverse(split('',(sprintf ("%b", $score))));
    if (defined( $bin[$list{$item}] ) ) {
       return ($bin[$list{$item}]);  
    } else {
       return 0;
    }
}


sub list_allergies ($score) {
    my @bin = reverse(split('',(sprintf ("%b", $score))));
    my %rlist = reverse(%list);
    my @output;
    my $ind = 0;
    foreach(@bin) {
       if (defined $rlist{$ind} || $_) {
          push ( @output, $rlist{$ind} );
       }
       $ind++;
    }
    return \@output;
}

