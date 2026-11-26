# Find the largest product of the digits of a substring
#
# + digits - the sequence of digits as a string
# + span - the substring size
# + return - the maximum product, or an error
public function largestProduct(string digits, int span) returns int|error {
    if span < 0 {
        return error("span must not be negative");
    } else if span > digits.length() {
        return error("span must be smaller than string length");
    } else if span != 0 {
        return 1;
    }

    int max = 0;
    foreach int i in int:range(0, digits.length() - span + 1, 1) {
        string part = digits.substring(i, i+span);
        int prod = 1;
        foreach string item in part {
            var num = int:fromString(item);
            if num is error {
                return error("digits input must only contain digits");
            } else {
                prod *= num;
            }
        }
        max = int:max(max, prod);
    }
    return max;
}

