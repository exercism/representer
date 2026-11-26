unit module NucleotideCount;

sub nucleotide-count($strand) is export {
    if $strand.comb.grep({ $_ !~~ /<[ACGT]>/ }) 
    {die "Invalid nucleotide in strand";}

    my $found = $strand.comb.Bag;
    my %counts = (
        A => ($found{'A'} // 0),
        C => ($found{'C'} // 0),
        G => ($found{'G'} // 0),
        T => ($found{'T'} // 0),
    );

    return %counts.Bag;
}
