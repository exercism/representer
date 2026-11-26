#include "scrabble_score.h"
#include <string>
#include <map>
#include <iostream>

namespace scrabble_score {
    std::map<char, int> mymap{
            {'a',1},{'e',1}, {'i', 1}, {'o', 1}, {'u',1},
                {'n',1},
                {'l',1},
                {'r',1},
                {'s',1},
                {'t',1},
                {'d',2},
                {'g',2},
                {'b',3},
                {'c',3},
                {'m',3},
                {'p',3},
                {'f',4},
                {'h',4},
                {'v',4},
                {'w',4},
                {'y',4},
                {'k',5},
                {'j',8},
                {'x',8},
                {'q',10},
                {'z',10},
            };
    int score(std::string mot){
        int res(0);
        for (size_t i =0; i < mot.size(); i++){
            char letter(mot[i]);
            if (std::isupper(letter)){
                letter += 32;
            }
            res += mymap[letter];
        }
        return res;

    }

}  // namespace scrabble_score
