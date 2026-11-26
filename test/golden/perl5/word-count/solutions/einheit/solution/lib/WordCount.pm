package WordCount;

use 5.40.0;

use Exporter qw<import>;
our @EXPORT_OK = qw<count_words>;

sub count_words ($sentence) {
    my %token_counts;

    while ($sentence =~ /(\w+(?:'\w+)?)/g) {
        my $word = lc($1); 
        $token_counts{$word}++;
    }

    return \%token_counts;
}

1;
