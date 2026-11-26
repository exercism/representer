
#!/usr/bin/awk -f

# Define the AWK script
BEGIN { FS = "\n"; ORS = ""; }

{
    if (NR == 0 && length($0) == 0) {
        print "One for you, one for me."
    } else {
        printf "One for %s, one for me.\n", $0;
    }
}

END {
    if (NR == 0) {
        print "One for you, one for me."
    }
}
