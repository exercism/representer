{
    if ($0 == "") {
        print ""
        exit
    }
    split($0, STR, "")
    len=length(STR)
    reversed = STR[len]

    while (--len) {
        reversed = reversed""STR[len]
    }
    print reversed
}
