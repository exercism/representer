BEGIN {
    FPAT = "..?.?"
    Stop = @/UAA|UAG|UGA/
    Protein["AUG"] = "Methionine"
    Protein["UGG"] = "Tryptophan"
    Protein["UUU"] = Protein["UUC"] = "Phenylalanine"
    Protein["UUA"] = Protein["UUG"] = "Leucine"
    Protein["UAU"] = Protein["UAC"] = "Tyrosine"
    Protein["UGU"] = Protein["UGC"] = "Cysteine"
    Protein["UCU"] = Protein["UCC"] = Protein["UCA"] = Protein["UCG"] = "Serine"
}

{
    for (i = 1; i <= NF; ++i)
        if ($i ~ Stop)
            NF = i - 1
        else
            $i = translate($i)
    print
}

function translate(codon) {
    if (codon in Protein)
        return Protein[codon]
    print "Invalid codon"
    exit 1
}
