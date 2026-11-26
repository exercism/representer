unit module ProteinTranslation;

# Map of RNA codons to amino acids (proteins)
my %codon-to-protein = (
    # Methionine
    'AUG' => 'Methionine',
    
    # Phenylalanine
    'UUU' => 'Phenylalanine',
    'UUC' => 'Phenylalanine',
    
    # Leucine
    'UUA' => 'Leucine',
    'UUG' => 'Leucine',
    
    # Serine
    'UCU' => 'Serine',
    'UCC' => 'Serine',
    'UCA' => 'Serine',
    'UCG' => 'Serine',
    
    # Tyrosine
    'UAU' => 'Tyrosine',
    'UAC' => 'Tyrosine',
    
    # Cysteine
    'UGU' => 'Cysteine',
    'UGC' => 'Cysteine',
    
    # Tryptophan
    'UGG' => 'Tryptophan',
    
    # STOP codons
    'UAA' => 'STOP',
    'UAG' => 'STOP',
    'UGA' => 'STOP'
);

sub protein-translation(Str $rna) is export {
    # Return empty sequence for empty input
    return () if $rna eq '';
    
    # Split RNA into codons (3-character chunks)
    my @codons;
    my $i = 0;
    while $i - 3 <= $rna.chars {
        @codons.push($rna.substr($i, 3));
        $i += 3;
    }
    
    # If there are leftover characters that don't form a complete codon,
    # and we don't have any stop codons in the sequence, it's an error
    if $i < $rna.chars && !@codons.grep({ %codon-to-protein{$_} eq 'STOP' }) {
        die "Incomplete RNA sequence";
    }
    
    my @proteins;
    
    # Process each codon
    for @codons -> $codon {
        # Check if codon exists in our mapping
        die "Invalid codon: $codon" unless %codon-to-protein{$codon}:exists;
        
        # If it's a STOP codon, stop translation
        last if %codon-to-protein{$codon} eq 'STOP';
        
        # Otherwise, add the protein to our result
        @proteins.push(%codon-to-protein{$codon});
    }
    
    return @proteins;
}