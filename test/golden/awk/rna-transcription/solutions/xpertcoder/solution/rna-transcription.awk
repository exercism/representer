NF {
n = split($0, word, "")
res=""
for(i=1;i<=n;i++) {
 if (word[i] == "G") res = res "C"
else if (word[i] == "C") res = res "G"
else if (word[i] == "T") res = res "A"
else if (word[i] == "A") res = res "U"
else { print("Invalid nucleotide detected."); exit_invoked = 1; exit 1;}
}
}
END {if (! exit_invoked  ) {print res}}