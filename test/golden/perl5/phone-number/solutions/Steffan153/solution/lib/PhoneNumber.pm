package PhoneNumber;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<clean_number>;

sub clean_number ($number) {
    local $_ = $number;
    y/+() .-//d;
    die '11 digits must start with 1' if /^[^1].{10}$/;
    die 'must not be greater than 11 digits' if y///c > 11;
    die 'must not be fewer than 10 digits' if y///c < 10;
    die 'letters not permitted' if /\p{L}/;
    die 'punctuations not permitted' if /\D/;
    s/1// if y///c > 10;
    die 'area code cannot start with zero' if /^0/;
    die 'area code cannot start with one' if /^1/;
    die 'exchange code cannot start with zero' if /^...0/;
    die 'exchange code cannot start with one' if /^...1/;
    $_
}

1;
