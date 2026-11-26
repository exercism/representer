USING: kernel assocs sequences unicode ;
IN: scrabble-score

MEMO: mappings ( -- map ) 
{
  { "AEIOULNRST" 1 }
  { "DG" 2 }
  { "BCMP" 3 }
  { "FHVWY" 4 }
  { "K" 5 }
  { "JX" 8 }
  { "QZ" 10 }
} 
[ swap [ swap ] with H{ } map>assoc ] 
{ } assoc>map 
assoc-union-all ;

: score ( word -- n )
  >upper [ mappings at ] map-sum ;
