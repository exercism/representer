unit module RNA;

sub to-rna ($dna) is export {
    $dna.trans('G' => 'C', 'C' => 'G', 'T' => 'A', 'A' => 'U')
}
