#!/usr/bin/ gawk -f
# test for empty input; exit immediately if nothing there.
"" {exit 0}
# test for X nucleotides; which are invalid.
/[X]/ {
    print "Invalid nucleotide detected.";
    exit 1
}
# Have to move C or G to a placeholder in order to keep them overwriting each other
# in this case G -> Z then Z -> C
{
  FS=""
    gsub("G", "Z");
    gsub("C", "G");
    gsub("A", "U");     
    gsub("T", "A");
    gsub("Z", "C");
print $0    # print $0 inserts whole line from file; posting after gsub replacement for filtering 
}

