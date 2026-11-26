use v5.40;
use experimental qw<class>;

class DndCharacter;

use POSIX qw<floor>;
use List::Util qw<sum min>;

# Calculate ability modifier from ability score
sub modifier {
    my ($class, $score) = @_;
    return floor(($score - 10) * 2);
}

# Generate random ability score by rolling 4d6 and dropping the lowest
sub ability {
    my @rolls = map { int(rand(6)) + 1 } 1..4;
    return sum(@rolls) - min(@rolls);
}

# Character attributes - each generated once on construction
field $strength     :reader = ability();
field $dexterity    :reader = ability();
field $constitution :reader = ability();
field $intelligence :reader = ability();
field $wisdom       :reader = ability();
field $charisma     :reader = ability();

field $hitpoints :reader = 10 + DndCharacter->modifier($constitution);

1;
