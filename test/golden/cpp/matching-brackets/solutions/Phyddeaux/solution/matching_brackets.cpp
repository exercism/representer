#include "matching_brackets.h"

namespace matching_brackets {
    bool check(const std::string& s){
        std::vector<char> vec_stack{};

        for (const auto &c : s){
            switch (c){
                case '(': case '[': case '{':
                    vec_stack.push_back(c);
                    break;
                case ')':case ']':case '}':
                    if( vec_stack.empty() || vec_stack.back()!=map_pairs.at(c) ){
                        return false;
                    }
                    vec_stack.pop_back();
                }
        }
        return vec_stack.size()==0;
    }
}