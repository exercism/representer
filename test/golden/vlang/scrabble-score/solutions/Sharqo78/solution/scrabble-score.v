module main

fn score(word string) int {
    map_points := {
        "aeioulnrst"    :    1,
        "dg"            :    2,
        "bcmp"          :    3,
        "fhvwy"         :    4,
        "k"             :    5,
        "jx"            :    8,
        "qz"            :   10
    }

    mut score := 0
    for chr in word.to_lower() {
        for letters, points in map_points {
            if letters.contains(chr.str_escaped()) {
                score += points
            }
        }
    }
    return score
}
