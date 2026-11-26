#include "beer_song.h"
#include <string>
namespace beer_song {
    std::string verse(int verseNb){
        std::string str {};
        std::string nb {std::to_string(verseNb)};
        std::string nbMinus {std::to_string(verseNb-1)};
        switch(verseNb){
            case 0:
                str += "No more" + Bottles + Wall + ", no more" + Bottles + Eol;
                str += Store + ", 99" + Bottles + Wall + Eol;
                break;
            case 1:
                str += nb + Bottle + Wall + ", " + nb + Bottle + Eol;
                str += Take + " it " + Pass + ", no more" + Bottles + Wall + Eol;
                break;
            case 2:
                str += nb + Bottles + Wall + ", " + nb + Bottles + Eol;
                str += Take + " one " + Pass + ", " + nbMinus + Bottle + Wall + Eol;
                break;
            default:
                str += nb + Bottles + Wall + ", " + nb + Bottles + Eol;
                str += Take + " one " + Pass + ", " + nbMinus + Bottles + Wall + Eol;
        }
        return str;
    }
    std::string sing(int from, int to){
        std::string song {};
        for(auto i {from}; i >= to; --i){
            song += verse(i);
            if(i != to)
                song += "\n";
        }
        return song;
    }
}  // namespace beer_song
