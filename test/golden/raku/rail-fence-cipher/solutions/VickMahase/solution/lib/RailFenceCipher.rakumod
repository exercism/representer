unit module RailFenceCipher;

# Encodes a message using the Rail Fence Cipher
sub zigzag-encode(Str $message, Int $rails) is export {
    # Handle edge cases
    return $message if $rails <= 1 || $message.chars <= 1;
    
    # Create rails (array to hold characters for each rail)
    my @fence = ["" xx $rails];
    
    # Traverse the message in zigzag pattern and place characters in rails
    my $rail = 0;
    my $direction = 1; # 1 for down, -1 for up
    
    for $message.comb -> $char {
        @fence[$rail] ~= $char;
        
        # Change direction when we hit the top or bottom rail
        if $rail == 0 {
            $direction = 1;  # Going down
        } elsif $rail == $rails - 1 {
            $direction = -1; # Going up
        }
        
        $rail += $direction;
    }
    
    # Read off the encoded message by joining all rails
    return @fence.join;
}

# Decodes a message encoded with the Rail Fence Cipher
sub zigzag-decode(Str $encoded, Int $rails) is export {
    # Handle edge cases
    return $encoded if $rails <= 1 || $encoded.chars <= 1;
    
    my $len = $encoded.chars;
    
    # Create a 2D fence pattern with the right dimensions
    my @fence;
    for ^$rails -> $r {
        @fence[$r] = [Nil xx $len];
    }
    
    # Mark positions in the fence pattern
    my $rail = 0;
    my $direction = 1;
    
    for ^$len -> $i {
        @fence[$rail][$i] = ''; # Mark position
        
        # Change direction when we hit the top or bottom rail
        if $rail == 0 {
            $direction = 1;  # Going down
        } elsif $rail == $rails - 1 {
            $direction = -1; # Going up
        }
        
        $rail += $direction;
    }
    
    # Fill the fence with the encoded message
    my $index = 0;
    for ^$rails -> $r {
        for ^$len -> $c {
            if defined(@fence[$r][$c]) {
                @fence[$r][$c] = $encoded.substr($index, 1);
                $index++;
            }
        }
    }
    
    # Read off the decoded message
    my $result = '';
    $rail = 0;
    $direction = 1;
    
    for ^$len -> $i {
        $result ~= @fence[$rail][$i] if defined(@fence[$rail][$i]);
        
        # Change direction when we hit the top or bottom rail
        if $rail == 0 {
            $direction = 1;  # Going down
        } elsif $rail == $rails - 1 {
            $direction = -1; # Going up
        }
        
        $rail += $direction;
    }
    
    return $result;
}