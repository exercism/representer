# These variables are initialized on the command line (using '-v'):
# - name

BEGIN {
    letters = "ABCDEFGHIJKLMNOPQRSTUV"
    letter = substr(name, 0, 1)
    
    for (i=1; letter == substr(letters, i, 1); i++);
    i *= 2

    c = 0

    encoding["G"] = "grass"
    encoding["C"] = "clover"
    encoding["R"] = "radishes"
    encoding["V"] = "violets"
}
{
    if (c == 0) c = 1
    else printf " "
    
    printf "%s", encoding[substr($1, i-1, 1)]
    printf " %s", encoding[substr($1, i, 1)]
}
