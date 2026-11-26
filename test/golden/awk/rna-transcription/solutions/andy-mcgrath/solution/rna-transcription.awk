# Validation, only allow charaters G, C, T and A or an empty string
!/^[GCTA]*$/ { 
    print "Invalid nucleotide detected."
    exit 1
}

# Set Output Record Separator (ORS) to empty string
# Split input string int characters and print translated character.
{
    ORS = ""
    translate["G"] = "C"
    translate["C"] = "G"
    translate["T"] = "A"
    translate["A"] = "U"
    
    split($0, dna, "");
    for (i=1; i <= length($0); i++) {
        print(translate[dna[i]])
    }
}