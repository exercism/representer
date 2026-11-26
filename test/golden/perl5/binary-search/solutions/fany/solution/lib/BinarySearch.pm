package BinarySearch;

use v5.40;
use feature 'switch';

use Exporter qw<import>;
our @EXPORT_OK = qw<binary_search>;

sub binary_search ( $array, $value ) {
    for ( my $lower = 0, my $upper = @$array; $lower < $upper; ) {
        given ( $array->[ my $middle = ($lower+$upper) >> 1 ] <=> $value ) {
            when ( 0) { return $middle       }
            when (-1) { $lower = $middle + 1 }
            when ( 1) { $upper = $middle     }
        }
    }
    die 'value not in array';
}

1;
