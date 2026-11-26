type Threshold record {
    int value;
    string symbol;
};

Threshold[] thresholds = [
    {value: 1000, symbol: "M"},
    {value: 900, symbol: "CM"},
    {value: 500, symbol: "D"},
    {value: 400, symbol: "CD"},
    {value: 100, symbol: "C"},
    {value: 90, symbol: "XC"},
    {value: 50, symbol: "L"},
    {value: 40, symbol: "XL"},
    {value: 10, symbol: "X"},
    {value: 9, symbol: "IX"},
    {value: 5, symbol: "V"},
    {value: 4, symbol: "IV"},
    {value: 1, symbol: "I"}
];

# Convert an integer to a Roman number.
#
# + number - the integer to convert
# + return - the Roman number as a string
function roman(int number) returns string {
    if number <= 0 || number >= 4000 {
        return "";
    }

    string result = "";
    int v = number;
    while v > 0 {
        foreach Threshold t in thresholds {
            if v >= t.value {
                result += t.symbol;
                v -= t.value;
                break;
            }
        }
    }

    return result;
}
