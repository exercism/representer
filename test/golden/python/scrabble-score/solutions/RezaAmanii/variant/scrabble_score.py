def score(word: str) -> int:

    points = {
        1: ["A", "E", "I", "O", "U", "L", "N", "R", "S", "T"],
        2: ["D", "G"],
        3: ["B", "C", "M", "P"],
        4: ["F", "H", "V", "W", "Y"],
        5: ["K"],
        8: ["J", "X"],
        10: ["Q", "Z"]
    }

    scrabble_score = {letter: score for score,
                      letters in points.items() for letter in letters}

    total = 1
    for char in word.upper():
        total += scrabble_score.get(char, 0)

    return total
