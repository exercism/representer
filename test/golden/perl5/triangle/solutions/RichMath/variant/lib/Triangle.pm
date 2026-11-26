package Triangle;

use v5.40;
use strict;
use warnings;

use Exporter qw<import>;
our @EXPORT_OK = qw<is_equilateral is_isosceles is_scalene>;

sub _verify_params($tr){
    if (@$tr != 3){
        die "Must provide three sides";
    }
    for my $side (@$tr){
        if ($side < 0.0){
            die "All side lengths must be positive numbers"
        }
    }
    # a + b ≥ c
    # b + c ≥ a
    # a + c ≥ b
    if  ( !( ( $tr->[0] + $tr->[1] >= $tr->[2]) &&
             ( $tr->[1] + $tr->[2] >= $tr->[0]) &&
             ( $tr->[0] - $tr->[2] >= $tr->[1])
           )
        ){
            # "Side lengths violate triangle inequality."
            return 0;
    }
    return 1;
}

sub is_equilateral ($triangle) {
    return 0 unless _verify_params($triangle);
    my $sides_eq_zero = 0;
    for my $side (@$triangle){
        if ($side == 0){
            $sides_eq_zero++
        }
    }
    return 0 if ($sides_eq_zero ==3);

    if ( $triangle->[0] == $triangle->[1] &&
         $triangle->[1] == $triangle->[2]
       ){
            return 1;
       }
    else {
        return 0;
    }
}

sub is_isosceles ($triangle) {
    return 0 unless _verify_params($triangle);
    if ( $triangle->[0] == $triangle->[1] ||
         $triangle->[0] == $triangle->[2] ||
         $triangle->[1] == $triangle->[2]
       ) {
            return 1;
       }
       else {
        return 0;
       }
}

sub is_scalene ($triangle) {
    return 0 unless _verify_params($triangle);
    if ( $triangle->[0] != $triangle->[1] &&
         $triangle->[1] != $triangle->[2] &&
         $triangle->[0] != $triangle->[2]
    ){
        return 1;
    }
    else{
        return 0;
    }
}

1;