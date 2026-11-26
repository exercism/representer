# Returns the acronym of the given phrase.
#
# + phrase - a string
# + return - the acronym
function abbreviate(string phrase) returns string {
    string acronym = "";
    boolean isNextSeprator = true;

    var isSeprator = function(string letter) returns boolean {
        match letter {
            " "|"-" => {
                return true;
            }
            _ => {
                return false;
            }
        }
    };

    foreach var letter in phrase.toUpperAscii() {
        if isSeprator(letter) {
            isNextSeprator = true;
        } else if isNextSeprator && letter >= "A" && letter <= "Z" {
            acronym += letter;
            isNextSeprator = false;
        }
    }

    return acronym;
}
