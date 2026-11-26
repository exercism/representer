unit module FlattenArray;

sub flatten-array ($nested) is export {
    my sub unpack-all($item) {
        gather {
            if $item ~~ Positional {
                for $item.list -> $elem {
                    take $_ for unpack-all($elem);
                }
            } elsif $item.defined {
                take $item;
            }
        }
    }

    [ unpack-all($nested) ];
}