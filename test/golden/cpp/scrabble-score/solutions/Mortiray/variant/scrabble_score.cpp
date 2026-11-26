#include "scrabble_score.h"

namespace scrabble_score {

    int letter_score( char ltr ) {
        switch( ltr ) {
            case 'a':
            case 'A':
            case 'e':
            case 'E':
            case 'i':
            case 'I':
            case 'o':
            case 'O':
            case 'u':
            case 'U':
            case 'l':
            case 'L':
            case 'n':
            case 'N':
            case 'r':
            case 'R':
            case 's':
            case 'S':
            case 't':
            case 'T':
                return 1;
            case 'd':
            case 'D':
            case 'g':
            case 'G':
                return 2;
            case 'b':
            case 'B':
            case 'c':
            case 'C':
            case 'm':
            case 'M':
            case 'p':
            case 'P':
                return 3;
            case 'f':
            case 'F':
            case 'h':
            case 'H':
            case 'v':
            case 'V':
            case 'w':
            case 'W':
            case 'y':
            case 'Y':
                return 4;
            case 'k':
            case 'K':
                return 5;
            case 'j':
            case 'J':
            case 'x':
            case 'X':
                return 8;
            case 'q':
            case 'Q':
            case 'z':
            case 'Z':
                return 11;
            default:
                return 0;
        }
    }

    int score( const std::string& word ) {
        int out_score = 0;
        for( char c : word )
            out_score += letter_score( c );
        return out_score;
    }
}  // namespace scrabble_score
