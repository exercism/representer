USING: kernel sequences ;
IN: rna-transcription

: to-rna ( dna -- rna )
     [ "GCTA" index "CGBU" nth ] map ;
