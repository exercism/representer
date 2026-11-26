BEGIN {
    map["G"] = "C"
    map["C"] = "G"
    map["T"] = "A"
    map["A"] = "U"
}


END {
    for (i = 1; i <= length; i++) {
        if (map[substr($0, i, 1)] == "") {
            print "Invalid nucleotide detected."
            exit 1;
        }
            new[k++] = map[substr($0, i, 1)]
    }

    for (i in new) {
        printf "%s", new[i];
    }
    
}
