unit module Accumulate;

sub accumulate ( @list, &function ) is export {
    return @list.grep(&function).list
}
