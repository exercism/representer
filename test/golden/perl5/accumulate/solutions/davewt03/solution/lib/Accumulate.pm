package Accumulate;

use v5.38;

use Exporter qw<import>;
our @EXPORT_OK = qw<accumulate>;

sub accumulate ( $list, $func ) {
    for my $item (@$list){
        $item = $func->($item);
    }
    return $list;
}

 
