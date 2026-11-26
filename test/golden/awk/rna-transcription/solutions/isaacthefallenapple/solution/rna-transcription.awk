BEGIN {
    # go through lowercase avoids C->G->C recursion
    complements["C"] = "g"
    complements["G"] = "c"
    complements["T"] = "a"
    complements["A"] = "u"
}
{
    if (match($0, /[^AGTC]/)) {
        print "Invalid nucleotide detected."
        exit 1
    }
    for (acid in complements) {
        gsub(acid, complements[acid])
    }
    print toupper($0)

}
