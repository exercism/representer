# These variables are initialized on the command line (using '-v'):
# - type
# - key
@load "ordchr"

function transform(f) {
    ki = 1
    s = ""
    for (ti = 1; ti <= length($0); ti++) {
        key_code = ord(substr(key, ki, 1)) - ord("a")
        text_code = ord(substr($0, ti, 1)) - ord("a")
        s = s chr((text_code + 26 + f * key_code) % 26 + ord("a"))
        ki++
        if (ki > length(key)) ki = 1
    }
    print s
}

{ $0 = tolower($0) }
type == "encode" && key ~ /[a-z]+/ { transform( 1) }
type == "decode" && key ~ /[a-z]+/ { transform(-1) }
END {
    if (!key) {
        s = ""
        for (i = 1; i <= 100; i++)
            s = s chr(rand() * 26 + ord("a"))
        print s
    } else if (key !~ /[a-z]+/) {
        print "invalid key"
        exit 1
    }
}