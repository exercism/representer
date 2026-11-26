#include "pangram.h"
#include <string>
#include <cctype>
#include <map>
#include <iterator>
    
namespace pangram {
    bool is_pangram(std::string sentence) {
        std::map<char, int> alphaMap = {
            { 'a', 0 },
            { 'b', 0 },
            { 'c', 0 },
            { 'd', 0 },
            { 'e', 0 },
            { 'f', 0 },
            { 'g', 0 },
            { 'h', 0 },
            { 'i', 0 },
            { 'j', 0 },
            { 'k', 0 },
            { 'l', 0 },
            { 'm', 0 },
            { 'n', 0 },
            { 'o', 0 },
            { 'p', 0 },
            { 'q', 0 },
            { 'r', 0 },
            { 's', 0 },
            { 't', 0 },
            { 'u', 0 },
            { 'v', 0 },
            { 'w', 0 },
            { 'x', 0 },
            { 'y', 0 },
            { 'z', 0 },
    
        };
        std::map<char, int>::iterator itr;
        int strLength = sentence.length();
        char y;
        for(int i = 0; i <= strLength; i++, y = sentence[i]) {
            if(isalpha(y) != 0) {
                for(itr = alphaMap.begin(); itr != alphaMap.end(); ++itr) {
                    if(std::tolower(y) == itr->first) {
                        alphaMap[itr->first] += 1;
                    }
                }
            }
        }
        bool allChar = true;
        for(itr = alphaMap.begin(); itr != alphaMap.end(); ++itr) {
            if(itr->second == 0) {allChar = false;}
        }
        return allChar;
    }
}  // namespace pangram
