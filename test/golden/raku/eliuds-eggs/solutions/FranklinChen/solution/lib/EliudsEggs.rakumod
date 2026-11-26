unit module EliudsEggs;

sub count-eggs ( $display ) is export {
    my $result = 0;
    my $remaining = $display;

    while $remaining != 0 {
        $result += ($remaining +& 1);
        $remaining = $remaining +> 1;
    }

    return $result;
}