package Series;

use v5.38;

use Exporter qw<import>;
our @EXPORT_OK = qw<slices>;

sub slices ( $series, $slice_length ) {
    die "series cannot be empty" if length($series) <= 0;
    die "slice length cannot be greater than series length" if ($slice_length > length($series));
    die "slice length cannot be zero" if $slice_length == 0;
    die "slice length cannot be negative" if $slice_length < 0;
    my @slice;
    my $i = 0;
    while ($i <= length($series) - $slice_length) {
        push(@slice, substr($series, $i++, $slice_length));
    }
    
    return \@slice;
}
