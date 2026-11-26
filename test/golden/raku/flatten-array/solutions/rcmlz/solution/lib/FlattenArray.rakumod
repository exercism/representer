unit module FlattenArray;

sub flatten-array (@nested --> Array(Seq)) is export {
    grep *.defined, gather @nested.hyper.deepmap: *.take
}
