package LanguageList;

use v5.40;

our @Languages;

sub add_language ($language) {
    push(@Languages, $language);
    return 1;
}

sub remove_language () {
    pop(@Languages);
    return 1;
}

sub first_language () {
    return $Languages[0];
}

sub last_language () {
    return $Languages[-1];
}

sub get_languages (@ele) {
    my @ans = ();
    my @indexes = @_;
    
    foreach my $idx (@ele) {
        push(@ans, $Languages[$idx + 1]);
    } 
    return @ans;
}

sub has_language ($language) {

    for my $i (@Languages) {
    
        return 1 if $language eq $i;
        }            
        return 0;
    
}

1;
