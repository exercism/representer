unit module SecretHandshake;

sub handshake ( $num ) is export {

    my @res;

    @res.push: 'wink' if $num +& 1;
    @res.push: 'double blink' if $num +& 2;
    @res.push: 'close your eyes' if $num +& 4;
    @res.push: 'jump' if $num +& 8;
    
    @res = @res.reverse if $num +& 16;

    return @res;
}
