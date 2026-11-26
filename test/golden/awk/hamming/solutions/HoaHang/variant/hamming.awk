BEGIN { count = 0 }
{ line[NR] = $0 } # remember for each input line
END {
    if (NR==2) { print "Wrong format"; exit 1 }
    if (length(line[1]) != length(line[2])){
        print "strands must be of equal length"
        exit 1
    }
    else{
        for (i=1; i<=length(line[1]); i++){
            if (substr(line[1],i,1) != substr(line[2],i,1)) count++
        }
        print count
    }
}