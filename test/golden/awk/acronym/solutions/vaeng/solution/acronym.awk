BEGIN {
    FS = "[_ -]";
    acronym = "";
}

{
    for(i = 1; i <= NF; i += 1)
       acronym = acronym substr(toupper($i), 1, 1);
}

END {
    print acronym;
}
