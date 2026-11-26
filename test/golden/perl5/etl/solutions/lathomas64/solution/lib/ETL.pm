package ETL;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<transform>;

sub transform ($data) {
    my %result;
    for my $score (keys %$data)
    {
        foreach my $letter ($data->{$score}->@*)
        {
            $result{lc($letter)} = $score;
        }
    }
    return {%result};
}

1;
