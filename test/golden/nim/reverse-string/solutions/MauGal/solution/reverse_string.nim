proc reverse*(s: string): string =
    let x: int = s.len - 1
    var s_reverse: string
    if s == "":
        return ""
    else:
        for i in 0..x:
            s_reverse = s[i] & s_reverse
        return s_reverse

#[ var word: string
echo "Inserisci una parola: "
word = readLine(stdin)
echo "Reverse di '",word,"' è: ", reverse(word)
 ]#