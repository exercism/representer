package Accumulate;

use v5.41;

use Exporter qw<import>;
our @EXPORT_OK = qw<accumulate>;

sub accumulate ( $list, $func ) {
    my @result_list;
    
    foreach my $element ($list->@*) {
        push(@result_list, $func->($element));
    }
    
    return \@result_list;
}

1;
