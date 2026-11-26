unit module FlattenArray;

sub flatten-array (@nested --> Array(Seq)) is export {
    map *.defined, gather @nested.hyper.deepmap: *.take
}
