unit module KindergartenGarden;

constant %PLANTS = 
    :C<clover>,
    :G<grass>,
    :R<radishes>,
    :V<violets>,
;

constant @STUDENTS = <
    Alice Bob Charlie David Eve Fred Ginny Harriet Ileana Joseph Kincaid Larry
>;

sub plants (:$diagram, :$student) is export {
    my $idx = @STUDENTS.first($student, :k);
    my $offset = $idx * 2;
    my ($row1, $row2) = $diagram.lines;

    my @codes = (
        $row1.substr($offset, 1),
        $row1.substr($offset + 1, 1),
        $row2.substr($offset, 1),
        $row2.substr($offset + 1, 1),
    );

    @codes.map({ %PLANTS{$_} }).List;
}