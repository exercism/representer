unit module LanguageList;

sub add-language (@languages, $language) is export {
    return |@languages, $language;
}

sub remove-language (@languages) is export {
    return @languages.head(*-1);
}

sub first-language (@languages) is export {
    return @languages.head;
}

sub last-language (@languages) is export {
    return @languages.tail;
}

sub get-languages (@languages, @elems) is export {
    return @languages[@elems.map(*-1)]
}

sub has-language (@languages, $language) is export {
    @languages.any eq $language;
}
