package FoodChain;

use v5.38;

use Exporter qw<import>;
our @EXPORT_OK = qw<recite>;

sub recite ( $start, $end ) {
    my $startverse="I know an old lady who swallowed a ";
    my @animals = ('','fly','spider','bird','cat','dog','goat','cow','horse');
    my @end = ('',"I don't know why she swallowed the fly. Perhaps she'll die.",'It wriggled and jiggled and tickled inside her.','How absurd to swallow a bird!','Imagine that, to swallow a cat!','What a hog, to swallow a dog!','Just opened her throat and swallowed a goat!',"I don't know how she swallowed a cow!","She's dead, of course!");
    my $middle1 = 'She swallowed the ';
    my $middle2 = ' to catch the ';
    my @ans;

    
    for (my $outer=$start;$outer<$end+1;$outer++){
        if ($outer!=$start){
            push @ans,"";
        }
        push @ans,$startverse . $animals[$outer] . ".";
        push @ans,$end[$outer];
        if ($outer!=8){
            for (my $inner=$outer-1;$inner>0;$inner--){
                if( $inner!= 2){
                    push @ans,$middle1 . $animals[$inner+1] . $middle2 . $animals[$inner] . ".";

                }
                else{
                    push @ans,$middle1 . $animals[$inner+1] . $middle2 . $animals[$inner] . ' that '. substr($end[2],3);

                    }
            }
            if ($outer!=1){
                push @ans,$end[1];
            }
        }
    }

    
     return join "\n", @ans;

}
