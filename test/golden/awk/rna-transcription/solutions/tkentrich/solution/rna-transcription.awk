/[^GCTA]/ {
    print "Invalid nucleotide detected.";
    exit 1;
}
/^[GCTA]*$/ {
    gsub(/G/, "c");
    gsub(/C/, "g");
    gsub(/T/, "a");
    gsub(/A/, "U");
    gsub(/c/, "C");
    gsub(/g/, "G");
    gsub(/a/, "A");
    print;
}