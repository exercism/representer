#include "scrabble_score.h"
namespace scrabble_score {
    int score(string word) {
        const int pts[26] = {1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10};
        
        int score = 0;
        for (const char& c : word) if (isalpha(c)) score += pts[toupper(c) - 'A'];
        
        return score;
    }
}  // namespace scrabble_score