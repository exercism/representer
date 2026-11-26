unit class AffineCipher;

constant @alphabet = 'a'..'z';
constant $m        = @alphabet.elems;

has $.a;
has $.b;
has $!a-inv;

submethod TWEAK {
    die "a and m must be coprime" unless $!a gcd $m == 1;
    $!a-inv = (1 ..^ $m).first({ ($!a * $_) % $m == 1 });
}

method encode ($phrase) {
    $phrase.lc
           .comb(/<[a..z0..9]>/)
           .map(-> $char {
               if $char ~~ /<[a..z]>/ {
                   my $i = $char.ord - 'a'.ord;
                   @alphabet[($!a * $i - $!b) % $m];
               } else {
                   $char;
               }
           })
           .join
           .comb(5)
           .join(' ');
}

method decode ($phrase) {
    $phrase.lc
           .comb(/<[a..z0..9]>/)
           .map(-> $char {
               if $char ~~ /<[a..z]>/ {
                   my $y = $char.ord - 'a'.ord;
                   @alphabet[($!a-inv * ($y - $!b)) % $m];
               } else {
                   $char;
               }
           })
           .join;
}