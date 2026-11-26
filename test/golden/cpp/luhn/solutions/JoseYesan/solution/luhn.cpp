#include "luhn.h"

#include <cctype>
#include <algorithm>
#include <numeric>
#include <regex>

namespace luhn {
    
     
    bool valid (std::string card_number){
        
        card_number.erase(std::remove(card_number.begin(), card_number.end(), ' '), card_number.end());
        
        if(card_number.length() <= 1){
            return false;
        }
        
        regex re("\\d+");
        
            if (!regex_match(card_number, re)) return false;
            
            int i=0;
            
            for (auto it = card_number.rbegin(); it != card_number.rend(); it++){
                if(i%2!=0){
                    char c = (*it - '0')*2;
                    *it = '0' + ((c > 9) ? c -= 9: c);
                }
                i++;
            }
        int sum = accumulate(card_number.begin(), card_number.end(), 0, [](int init, char charCode){return init + (charCode - '0');});
         
        return (sum%10==0);
    }
}  // namespace luhn

