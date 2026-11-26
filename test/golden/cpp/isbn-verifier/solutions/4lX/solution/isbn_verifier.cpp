#include "isbn_verifier.h"
#include <iostream>
namespace isbn_verifier {
    bool is_valid(std::string aCode){
        int res{0}, cpt{10}, intChar{};
        for(std::size_t i = 0; i<aCode.size(); ++i){
            intChar = aCode[i] - '\0';
            std::cout << std::to_string(intChar-48) << "*" << std::to_string(cpt) << std::endl;
            if(aCode[i]=='-') continue;
            else if ((intChar<48 || (intChar>57 && intChar != 88)) || cpt<1) return false;
            else if(aCode[i]=='X') res += 10;
            else {
                res+= (aCode[i]-'0') * cpt;
            }
            cpt--;
        }       
        if(cpt>0)return false;
        std::cout << res << std::endl;
        return (res%11 == 0);
    };
}  // namespace isbn_verifier