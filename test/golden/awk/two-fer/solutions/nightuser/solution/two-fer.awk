NF {printf("One for %s, one for me.\n", $0)}
END {if (!NF) print "One for you, one for me."}
