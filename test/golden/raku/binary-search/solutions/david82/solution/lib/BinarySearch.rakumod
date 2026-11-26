unit module BinarySearch;

sub binary-search (:@array, :$value) is export {
    my Int $left  = 0;
    my Int $right = @array.elems - 1;

    while $left <= $right {
        my Int $mid = ($left + $right) div 2;

        if @array[$mid] == $value {
            return $mid;
        } elsif @array[$mid] < $value {
            $left = $mid + 1;
        } else {
            $right = $mid - 1;
        }
    }

    die "value not in array";
}