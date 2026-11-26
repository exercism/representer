unit module Scrabble;

sub scrabble-score ($word) is export {
#            Letter                  Value
constant
  %ptab = ( <A E I O U L N R S T>,     1,
            <D G>,                     2,
            <B C M P>,                 3,
            <F H V W Y>,               4,
            <K>,                       5,
            <J X>,                     8,
            <Q Z>,                    10 ).map({ $^b => $^a }).invert;
         
    %ptab{ $word.uc.comb }.sum
}
