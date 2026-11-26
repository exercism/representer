@include "assert"

BEGIN {
    # Associative array of band colors and their value
    bands["black"] = 0;
	bands["brown"] = 1;
	bands["red"] = 2;
	bands["orange"] = 3;
	bands["yellow"] = 4;
	bands["green"] = 5;
	bands["blue"] = 6;
	bands["violet"] = 7;
	bands["grey"] = 8;
	bands["white"] = 9;
}

# The input to our program is a single record with
# fields that correspond to the colors on the resistor.
# 
# Each record: "color1 color2"
{
    assert($1 in bands || $2 in bands, "invalid color");

    printf "%d\n", bands[$1] * 10 + bands[$2];
}