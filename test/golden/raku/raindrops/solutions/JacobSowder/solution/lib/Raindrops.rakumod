unit module Raindrops;

sub raindrop ($num) is export {
    my $result;
    given $num {
	when $_ %% 3 {
	    $result ~= 'Pling';
	    proceed
	}
	when $_ %% 5 {
	    $result ~= 'Plang';
	    proceed
	}
	when $_ %% 7 {
	    $result ~= 'Plong';
	}
    }

    return $result if $result.DEFINITE;
    $num.Str;
}
