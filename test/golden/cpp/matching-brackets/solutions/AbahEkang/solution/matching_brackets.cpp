#include "matching_brackets.h"


namespace matching_brackets {

    bool check(std::string line){

        std::deque<char> matches{};
        std::unordered_map<char, char> symbols{{'(', ')'}, {'{', '}'}, {'[', ']'}};
        
        for(auto ch: line){
           if(symbols.find(ch) != symbols.end()){
               matches.push_back(ch);
           }else if(ch == ')' || ch == '}' || ch == ']'){
               // matches.empty() before 'ch' equality prevents from accessing bad memory
               if(matches.empty()  || ch != symbols[matches.back()]){
                   return false;
               }
                matches.pop_back();
           }
        }

        //true if all the symbols mactched
        return matches.empty();
    }
        




}  // namespace matching_brackets
