package NucleotideCount;

use v5.39;

use Exporter qw<import>;
our @EXPORT_OK = qw<count_nucleotides>;

sub count_nucleotides ($strand) {
    my @strand = split(//,$strand);
    my %output = ('A'=>0, 'C'=>0, 'G'=>0, 'T'=>0 );
    for (my $i=0; $i<scalar(@strand); $i++) {
        my $flag = exists $output{$strand[$i]} ? "Ok" : "Error";
        if ($flag eq "Ok"){
            $output{$strand[$i]}++;
        }else{
            die 'Invalid nucleotide in strand';
        }
    }
    return \%output;
}

1;
