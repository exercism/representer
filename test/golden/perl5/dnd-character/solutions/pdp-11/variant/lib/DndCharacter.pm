use v5.40;
use experimental qw<class>;

class DndCharacter {
	sub modifier ($cls, $n) {
		return int($n/2)+5;
	}
	
	sub ability ($cls) {
		my @dice = sort {$a <=> $b} map {1 + int rand(6)} 1 .. 4;
		my $sum = 0; 
		$sum += $_ foreach @dice[1, 2, 3];
		return $sum;
	}

	field $strength :reader;
	field $dexterity :reader;
	field $constitution :reader;
	field $intelligence :reader;
	field $wisdom :reader;
	field $charisma :reader;
	field $hitpoints :reader;

	ADJUST {
		$strength = $self->ability();
		$dexterity = $self->ability();
		$constitution = $self->ability();
		$intelligence = $self->ability();
		$wisdom = $self->ability();
		$charisma = $self->ability();
		$hitpoints = 10 + $self->modifier($self->constitution);
	}
};

# implement the DndCharacter class

1;
