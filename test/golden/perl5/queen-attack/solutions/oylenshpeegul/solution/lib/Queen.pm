use v5.40;
use experimental qw<class>;

class Queen;

field $row :reader :param;
field $column :reader :param;

ADJUST {
    die "row not on board" unless 0 <= $row <= 7;
    die "column not on board" unless 0 <= $column <= 7;
}

method can_attack ($other) {
    $self->row == $other->row
        or $self->column == $other->column
        or abs($self->row - $other->row) == abs($self->column - $other->column)
}

1;
