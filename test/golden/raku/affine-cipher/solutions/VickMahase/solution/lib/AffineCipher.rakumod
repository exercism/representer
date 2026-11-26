unit class AffineCipher;

constant @alphabet = 'a'..'z';
constant $m        = @alphabet.elems;

has $.a;
has $.b;

submethod TWEAK() {
    # Check if a and m are coprime (their GCD should be 1)
    die "Error: 'a' and 'm' must be coprime" unless gcd($!a, $m) == 1;
}

method encode($phrase) {
    # Normalize the input: remove non-alphanumeric chars, convert to lowercase
    my $normalized = $phrase.lc.comb(/\w/).join;
    
    # Encrypt each character
    my $encrypted = "";
    for $normalized.comb -> $char {
        # Digits are not encrypted
        if $char ~~ /\d/ {
            $encrypted ~= $char;
            next;
        }
        
        # Find the index of the character in the alphabet
        my $index = @alphabet.first($char, :k);
        
        # Apply the encryption formula: E(x) = (ax + b) mod m
        my $encrypted-index = ($!a * $index + $!b) % $m;
        $encrypted ~= @alphabet[$encrypted-index];
    }
    
    # Group ciphertext in groups of 5 letters separated by spaces
    my @chunks = $encrypted.comb(5);
    return @chunks.join(" ");
}

method decode($phrase) {
    # Remove all non-alphanumeric characters
    my $normalized = $phrase.lc.comb(/\w/).join;
    
    # Find the modular multiplicative inverse of a
    my $a_inverse = modular_inverse($!a, $m);
    
    # Decrypt each character
    my $decrypted = "";
    for $normalized.comb -> $char {
        # Digits are not decrypted
        if $char ~~ /\d/ {
            $decrypted ~= $char;
            next;
        }
        
        # Find the index of the character in the alphabet
        my $index = @alphabet.first($char, :k);
        
        # Apply the decryption formula: D(y) = a^-1 * (y - b) mod m
        # Need to ensure the result is positive by adding m before taking the modulo
        my $decrypted-index = ($a_inverse * ($index - $!b % $m) % $m + $m) % $m;
        $decrypted ~= @alphabet[$decrypted-index];
    }
    
    return $decrypted;
}

# Helper function to compute the greatest common divisor
sub gcd($a, $b) {
    my ($x, $y) = ($a, $b);
    while $y {
        ($x, $y) = ($y, $x % $y);
    }
    return $x;
}

# Helper function to find the modular multiplicative inverse
sub modular_inverse($a, $m) {
    # Extended Euclidean Algorithm to find modular multiplicative inverse
    my ($s, $t, $r) = (1, 0, $a);
    my ($s1, $t1, $r1) = (0, 1, $m);
    
    while $r1 != 0 {
        my $q = $r div $r1;
        ($r, $r1) = ($r1, $r - $q * $r1);
        ($s, $s1) = ($s1, $s - $q * $s1);
        ($t, $t1) = ($t1, $t - $q * $t1);
    }
    
    # If r > 1, a is not invertible
    die "Error: 'a' is not invertible modulo 'm'" if $r > 1;
    
    # Make sure the result is positive
    return ($s % $m + $m) % $m;
}