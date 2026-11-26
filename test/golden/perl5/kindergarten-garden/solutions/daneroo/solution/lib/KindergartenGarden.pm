package KindergartenGarden;

use v5.40;
use Exporter qw<import>;
our @EXPORT_OK = qw<plants>;

sub plants ( $diagram, $student ) {
    my %plants = (
        C => 'clover',
        G => 'grass',
        R => 'radishes',
        V => 'violets',
    );

    my @children = qw<
        Alice Bob Charlie David Eve Fred Ginny Harriet Ileana Joseph Kincaid Larry
    >;

    # Split the diagram into two rows
    my @rows = split /\n/, $diagram;

    # Find the index of the student in the @children array
    my $index = 0;
    $index++ until $children[$index] eq $student;

    # Each student has 2 cups from each row, starting at index * 2
    my $start = $index * 2;
    my @student_plants = (
        @plants{split //, substr( $rows[0], $start, 2 )},
        @plants{split //, substr( $rows[1], $start, 2 )}
    );

    # Return an array reference
    return \@student_plants;
}

1;
