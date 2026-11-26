NF {printf("One for %s, ooe for me.\n", $0)}
END {if (!NF) print "One for you, one for me."}
