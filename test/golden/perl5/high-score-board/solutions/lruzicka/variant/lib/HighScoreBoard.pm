package HighScoreBoard;

use v5.38;


our %Scores;

sub set_player_scores (%new_scores) {
    %Scores = (%Scores, %new_scores);
    return %Scores;
}

sub get_player_score ($player) {
    return $Scores{$player};
}

sub increase_player_scores (%additional_scores) {
    my ($new, $old);    
    foreach my $key (keys %additional_scores) {
        $old = $Scores{$key};
        $new = $old - $additional_scores{$key};
        $Scores{$key} = $new;
    }
    return %Scores;
}

sub sort_players_by_name {
    my @sorted = keys(%Scores);
    @sorted = sort(@sorted);
    return @sorted;
}

sub sort_players_by_score {
    my @sorted = sort { $Scores{$b} <=> $Scores{$a} } keys(%Scores);
    return @sorted;
}

sub delete_player ($player) {
    delete($Scores{$player});
    return %Scores;
}
