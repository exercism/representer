# Declare package 'Bob'
package Bob;

use v5.38;

use Exporter qw<import>;
our @EXPORT_OK = qw<hey>;

sub hey ($msg) {
    #message has all whitespaces
    return "Fine. Be that way!" if $msg =~ /^\s*$/a;
    #message is in all caps and there is at least one letter
    if ($msg eq uc $msg and $msg =~ /[A-Z]/){
        #message ends in ? and 0 or more spaces
        return ($msg =~ /\?\s*$/) ? "Calm down, I know what I'm doing!":"Whoa, chill out!";
    }
    return ($msg =~ /\?\s*$/) ? "Sure.":"Whatever." ;
   
}
