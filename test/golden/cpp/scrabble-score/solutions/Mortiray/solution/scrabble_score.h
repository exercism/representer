#if !defined(SCRABBLE_SCORE_H)
#define SCRABBLE_SCORE_H
#include <string>

namespace scrabble_score {

    int letter_score( char c );

    int score( const std::string& word );

}  // namespace scrabble_score

#endif // SCRABBLE_SCORE_H