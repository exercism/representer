{
    number = $0
    gsub(/[ ]/, "", number)
    if (length(number) <= 1 || match(number, /[^0-9]/)) {
        print "false"
        exit
    }

    sum = 0
    split(number, split_num, "")
    len = length(split_num)
    offset = len % 2 == 0 ? 1 : 0
    
    for (i = 0; i < len; i++) {
        from_back = len - i
        digit = split_num[from_back]
        if (from_back % 2 == offset) {
            to_add = digit * 2
            sum += to_add > 9 ? to_add - 9 : to_add
        } else {
            sum += digit
        }
    }

    if (sum % 10 == 0) {
        print "true"
    } else {
        print "false"
    }
}
