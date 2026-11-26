USING: kernel regexp ;
IN: ledger-lookout

: valid-amount? ( line -- ? )
    R/ \$\d+(\.\d{2})?/ matches? ;

: dollar-amounts ( line -- amounts )
    R/ (?<=\$)\d+/ all-matching-subseqs ;

: percentages ( line -- nums )
    R/ \d+(?=%)/ all-matching-subseqs ;

: flagged? ( line -- ? )
    R/ \b(refund|chargeback)\b/i re-contains? ;
