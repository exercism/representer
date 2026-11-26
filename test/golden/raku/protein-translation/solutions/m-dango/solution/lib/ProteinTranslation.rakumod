unit module ProteinTranslation;

sub protein-translation ($strand) is export {
    gather for $strand.comb(3) {
        when 'AUG'           {take 'Methionine'}
        when 'UGG'           {take 'Tryptophan'}
        when /UU<[UC]>/      {take 'Phenylalanine'}
        when /UU<[AG]>/      {take 'Leucine'}
        when /UA<[UC]>/      {take 'Tyrosine'}
        when /UG<[UC]>/      {take 'Cysteine'}
        when /UC<[UCAG]>/    {take 'Serine'}
        when /U[A<[GA]>|GA]/ {last}
        default              {die}
    }
}
