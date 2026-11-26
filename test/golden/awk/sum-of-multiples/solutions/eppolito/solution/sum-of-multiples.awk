# These variables are initialized on the command line (using '-v'):
# - limit
{
    for (i=1; i<=NF; i++) {
        if ($i == 0) { continue }
        for (j=$i; j<limit; j+=$i) { score[j]=j }
    }
    for (s in score) { answer += s }
    print +answer
}
