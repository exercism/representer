# Determine the score of a set of dice against a Yacht category.
#
# + unsortedDice - an array of 5 integers
# + category - the name of a combination of dice
# + return - the score
public function score(int[] unsortedDice, string category) returns int {
    int[] dice = unsortedDice.sort();
    int sum = 0;
    map<int> counts = {};
    map<int> sums = {};
    foreach int die in dice {
        sum += die;
        string key = string `${die}`;
        sums[key] = (sums[key] ?: 0) + die;
        counts[key] = (counts[key] ?: 0) + 1;
    }

    var equal = function(int[] arr) returns boolean {
        foreach [int, int] [i, v] in arr.enumerate() {
            if dice[i] != v {
                return false;
            }
        }
        return true;
    };

    match category {
        "choice" => {
            return sum;
        }
        "four of a kind" => {
            if counts[string `${dice[0]}`] >= 4 {
                return dice[0] * 4;
            }
            if counts[string `${dice[1]}`] >= 4 {
                return dice[1] * 4;
            }
        }
        "full house" => {
            if (counts[string `${dice[0]}`] == 3 && counts[string `${dice[4]}`] == 2) ||
    (counts[string `${dice[0]}`] == 2 && counts[string `${dice[4]}`] == 3) {
                return sum;
            }
        }
        "little straight" => {
            if equal(littleStraight) {
                return 30;
            }
        }
        "big straight" => {
            if equal(bigStraight) {
                return 30;
            }
        }
        "ones" => {
            return sums["1"] ?: 0;
        }
        "twos" => {
            return sums["2"] ?: 0;
        }
        "threes" => {
            return sums["3"] ?: 0;
        }
        "fours" => {
            return sums["4"] ?: 0;
        }
        "fives" => {
            return sums["5"] ?: 0;
        }
        "sixes" => {
            return sums["6"] ?: 0;
        }
        "yacht" => {
            if sum == dice[0] * 5 {
                return 50;
            }
        }
    }

    return 0;
}

int[] littleStraight = [1, 2, 3, 4, 5];
int[] bigStraight = [2, 3, 4, 5, 6];
