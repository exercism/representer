use v5.32;
use experimental qw(isa);

package LinkedList;

sub new {
    my $class = shift;

    return $class->from_array(\@_);
}

sub from_array {
    my ($class, $values) = @_;

    return undef unless @$values;

    my $value = shift(@$values);
    my $self;
    if ($value isa $class) {
        $self = $value;
    }
    else {
        $self = bless {data => $value}, $class;
    }

    $self->{next} = $class->from_array($values);
    return $self;
}

sub to_array {
    my ($self) = @_;

    my $array   = [];
    my $current = $self;
    while ($current) {
        push @$array, $current->data;
        $current = $current->next;
    }
    return $array;
}

sub data { $_[0]->{data} }

sub next { $_[1]->{next} }

sub reverse {
    my ($self) = @_;

    my @elements;
    my $curr = $self;
    while ($curr) {
        my $next = $curr->{next};
        $curr->{next} = undef;
        push @elements, $curr;
        $curr = $next;
    }
    return LinkedList->new(reverse @elements);
}

1;
