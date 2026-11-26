package Acronym;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<abbreviate>;

sub abbreviate ($phrase) {
    $_ = $phrase;
    tr/-_/  /;
    s/([^ ])[^ ]+/$1/g;
    s/ *//g;
    tr/a-z/A-Z/;
    return $_;
}

1;
