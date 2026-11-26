unit module PhoneNumber;

constant @errors = (
   '11 digits must start with 1',
   'must not be greater than 11 digits',
   'must not be fewer than 10 digits',
   'letters not permitted',
   'punctuations not permitted',
   'area code cannot start with zero',
   'area code cannot start with one',
   'exchange code cannot start with zero',
   'exchange code cannot start with one',
);

sub clean-number ($number) is export {
    if $number.match(/ <alpha> /) { die @errors[3] }
    if $number.match(/ <-[ \d \s \+ \- \. \( \) ]> /) { die @errors[4] }

    my $digits = $number.match(/ \d+ /, :global).join;
    my $length = $digits.chars;
    if $length > 11 { die @errors[1] }
    elsif $length > 10 { 
        if substr($digits, 0, 1) != '1' { die @errors[0] }
        $digits = substr($digits, 1)
    } elsif $length < 10 { die @errors[2] }
    
    if substr($digits, 0, 1) == '0' { die @errors[5] }
    elsif substr($digits, 0, 1) == '1' { die @errors[6] }
    elsif substr($digits, 3, 1) == '0' { die @errors[7] }
    elsif substr($digits, 3, 1) == '1' { die @errors[8] }
    
    return $digits;
}
