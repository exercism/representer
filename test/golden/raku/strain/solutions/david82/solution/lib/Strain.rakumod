unit module Strain;

sub keep ( :@list, :&function ) is export {
    gather {
        for @list -> $item {
            take $item if function($item);
        }
    }.List;
}

sub discard ( :@list, :&function ) is export {
    gather {
        for @list -> $item {
            take $item unless function($item);
        }
    }.List;
}