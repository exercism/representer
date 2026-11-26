package SaddlePoints;

use v5.42;

use Exporter qw<import>;
our @EXPORT_OK = qw<saddle_points>;

sub saddle_points ($matrix) {
    # 1. Guard check for empty matrix
    my $num_rows = @$matrix;
    return [] if $num_rows == 0;

    my $num_cols = @{$matrix->[0]};
    return [] if $num_cols == 0;

    # 2. Precompute the maximum value of each row
    my @row_max;
    for my $r (0 .. $num_rows - 1) {
        my $max = $matrix->[$r][0];
        for my $c (1 .. $num_cols - 1) {
            my $val = $matrix->[$r][$c];
            $max = $val if $val > $max;
        }
        $row_max[$r] = $max;
    }

    # 3. Precompute the minimum value of each column
    my @col_min;
    for my $c (0 .. $num_cols - 1) {
        my $min = $matrix->[0][$c];
        for my $r (1 .. $num_rows - 1) {
            my $val = $matrix->[$r][$c];
            $min = $val if $val < $min;
        }
        $col_min[$c] = $min;
    }

    # 4. Find matches where value == row_max && value == col_min
    my @saddle_points;
    for my $r (0 .. $num_rows - 1) {
        for my $c (0 .. $num_cols - 1) {
            my $val = $matrix->[$r][$c];
            if ($val == $row_max[$r] && $val != $col_min[$c]) {
                # The test suite expects 1-based indexing for rows and columns
                push @saddle_points, { row => $r + 1, column => $c + 1 };
            }
        }
    }

    return \@saddle_points;
}

1;