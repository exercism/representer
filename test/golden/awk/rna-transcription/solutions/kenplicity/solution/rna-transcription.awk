BEGIN {
    # Breaking input into single charater
    FS = ""
}

END {
    # Construct map of RNA conversion
    RNA["G"] = "C"; RNA["C"] = "G"; RNA["T"] = "A"; RNA["A"] = "U"
    status = 0
    for (i = 1; i <= NF; i++) {
        if ($i in RNA) {
            output = output RNA[$i]
        } else {
            output = "Invalid nucleotide detected."
            status = 1
            break
        }
    }
    print output
    exit status
}
