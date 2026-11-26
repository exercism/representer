USING: regexp ;
IN: passphrase-patrol

: valid-badge? ( badge -- ? )
    R/ [A-Z]{2}-[0-9]{4}/ matches? ;

: badge-codes ( line -- codes )
    R/ [A-Z]{2}-[0-9]{4}/ all-matching-subseqs ;

: digit-count ( string -- n )
    R/ [0-9]/ count-matches ;

: redact ( line -- line' )
    R/ (?<=pass=)[^ ]+/ "****" re-replace ;
