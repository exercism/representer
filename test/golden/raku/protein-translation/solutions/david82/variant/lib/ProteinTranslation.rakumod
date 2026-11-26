unit module ProteinTranslation;

constant %CODON-MAP = (
    'AUG' => 'Methionine',
    'UUU' => 'Phenylalanine',
    'UUC' => 'Phenylalanine',
    'UUA' => 'Leucine',
    'UUG' => 'Leucine',
    'UCU' => 'Serine',
    'UCC' => 'Serine',
    'UCA' => 'Serine',
    'UCG' => 'Serine',
    'UAU' => 'Tyrosine',
    'UAC' => 'Tyrosine',
    'UGU' => 'Cysteine',
    'UGC' => 'Cysteine',
    'UGG' => 'Tryptophan',
    'UAA' => 'STOP',
    'UAG' => 'STOP',
    'UGA' => 'STOP',
);

sub protein-translation ($strand) is export {
    my @proteins;
    my $idx = 0;
    my $len = $strand.chars;

    while $idx <= $len {
        die 'Incomplete RNA sequence' if $idx + 3 > $len;

        my $codon = $strand.substr($idx, 3);
        die "Invalid codon: $codon" unless %CODON-MAP{$codon}:exists;

        my $val = %CODON-MAP{$codon};
        last if $val eq 'STOP';

        @proteins.push($val);
        $idx += 3;
    }

    @proteins.List;
}