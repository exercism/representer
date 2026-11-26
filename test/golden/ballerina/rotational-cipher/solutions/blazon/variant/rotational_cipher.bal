# Encodes the input text using the rotational cipher technique
#
# + text - the text to encode
# + shiftKey - the number of positions to shift each alphabetic character
# + return - the encoded text

function calculateRotatedCodePoint(int existing, int shift) returns int {

    // UPPERCASE: [65-90]
    // lowercase: [97-122]
    // (ref: https://www.ascii-code.com/)

    // char   + shift = newCP
    // 66 [b] + 1     = 67 [c]
    // 65 [a] + 26    = 91 - 90 + 64 = 65 [a]

    int newCP = existing;

    if existing >= 65 && existing <= 90 {
        newCP += shift;
        if newCP > 90 {
            newCP = newCP - 90 + 64;
        }
    } else if existing >= 97 && existing <= 122 {
        newCP += shift;
        if newCP >= 122 {
            newCP = newCP - 122 + 96;
        }
    }
    return newCP;
}

function rotate(string text, int shiftKey) returns string {

    // A string code point refers to the numerical value assigned to a character in a string, typically represented in Unicode.
    // https://central.ballerina.io/ballerina/lang.string/2201.12.7#toCodePointInt

    int[] stringAsCodePoints = text.toCodePointInts();
    int[] rotated = [];

    foreach int cp in stringAsCodePoints {
        rotated.push( calculateRotatedCodePoint(cp, shiftKey) );
    }

    string returnString = checkpanic string:fromCodePointInts(rotated);
    return returnString;
}
