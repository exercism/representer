package MicroBlog;

use v5.40;

use Exporter qw<import>;
our @EXPORT_OK = qw<truncate_post>;

sub truncate_post ($utf8_bytes) {
    utf8::decode($utf8_bytes);
    return substr $utf8_bytes, 0, 5;
}

1;
