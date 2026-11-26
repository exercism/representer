unit module SecretHandshake;

sub handshake ( $number ) is export {
    my Str @res;
    say $number;
    unless $number %% 2 {
        @res.push('wink');
    }

    unless ($number div 2) %% 2 {
        @res.push('double blink');
    }
    
    unless ($number div 4) %% 2 {
        @res.push('close your eyes');
    }

    unless ($number div 8) %% 2 {
        @res.push('jump');
    }

    unless ($number div 16) %% 2 {
        @res = reverse(@res);
    }

    return @res;
}
