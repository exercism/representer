# These variables are initialized on the command line (using '-v'):
# -direction

BEGIN {
    FS = ""
    keys = "abcdefghijklmnopqrstuvwxyz"
    cipher = "zyxwvutsrqponmlkjihgfedcba"
    for (ik = 1; ik <= 26; ik++) {
        key = substr(keys, ik, 1)
        code = substr(cipher, ik, 1)
        map[key] = code
        map[toupper(key)] = code
    }
}

END {
    processed = ""
    recoded = ""
    recode()
    if (direction == "encode") {
        for (ir = 1; ir <= length(recoded); ir += 5) {
            chunk = substr(recoded, ir, 5)
            processed = (processed) ? processed " " chunk : chunk
        }
    } else {
        processed = recoded
    }
    print processed
}

function recode(  ir) {
    for (ir = 1; ir <= NF; ir++) {
        if ($ir in map) {
            recoded = recoded map[$ir]
        } else if ($ir ~ /[0-9]/)  {
            recoded = recoded $ir
        } 
    }
}

