unit module Allergies;

my role BitmaskEnumeration {
    multi method ACCEPTS ( ::?CLASS:D: UInt:D $score --> Bool:D ) {
        so self +& $score;
    }
}

enum Allergen does BitmaskEnumeration is export (<
    Eggs
    Peanuts
    Shellfish
    Strawberries
    Tomatoes
    Chocolate
    Pollen
    Cats
> Z=> ( 1, * +< 2 … ∞ ) );

sub allergic-to ( Allergen:D :$item, :$score --> Bool:D ) is export {
    $score ~~ $item;
}

sub list-allergies ( $score --> Set[Allergen] ) is export {
    Set[Allergen].new( Allergen::.values.grep: $score ~~ * );
}
