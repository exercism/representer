import ballerina/regex;

# Returns the acronym of the given phrase.
#
# + phrase - a string
# + return - the acronym
# 
function abbreviate(string phrase) returns string {
    regex:Match[] matches = regex:searchAll(phrase.toUpperAscii(), "[A-Z][A-Z']*");
    return matches.map('match => 'match.matched[0])
                  .reduce(isolated function (string acc, string word) returns string => acc + word, "");
}
