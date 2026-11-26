import ballerina/lang.regexp;

# Returns the acronym of the given phrase.
#
# + phrase - a string
# + return - the acronym
function abbreviate(string phrase) returns string {
    string out = "";

    foreach string word in (re `[-\s]`).split(phrase) {
        regexp:Span? span = (re `[a-zA+Z]+`).find(word);
        out += span != () ? span.substring()[0].toUpperAscii() : "";
    }

    return out;
}
