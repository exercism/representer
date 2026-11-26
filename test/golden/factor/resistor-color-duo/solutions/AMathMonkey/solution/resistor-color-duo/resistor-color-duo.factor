USING: kernel math qw sequences ;
IN: resistor-color-duo

: value ( colors -- n )
    first2 
    [ qw{ black brown red orange yellow green blue violet grey white } index ] bi@ 
    [ 10 * ] dip + ;
