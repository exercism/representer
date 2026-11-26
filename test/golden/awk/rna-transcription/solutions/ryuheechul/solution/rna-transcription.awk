function convert(n) {
    if (n ~ "G")
        return "C"
    else if (n ~ "C")
        return "G"
    else if (n ~ "T")
        return "A"
    else if (n ~ "A")
        return "U"
}

/^[GCTA]+$/ {
    valid = $0
    split($0, nucleotides, "");

    for(key in nucleotides) {
        n = nucleotides[key];
        printf convert(n);
    }
}

$0 != valid {
    print "Invalid nucleotide detected."
    exit 1
}