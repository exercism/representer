#! /bin/awk -f

BEGIN {
    FS = "";
}

{
    for (i = NF; i >= 1; i = i - 1)
        rev = rev $i;
}            

END {
    print rev;
}