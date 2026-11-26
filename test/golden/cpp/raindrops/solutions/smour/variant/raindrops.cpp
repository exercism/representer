#include "raindrops.h"

namespace raindrops {
    std::string convert(int n){
        std::string result="";
        bool flag=true;
        if(n%3==0){
            result+="Pling";
            flag=false;
        }
        if(n%5==0){
            result+="Plang";
            flag=false;
        }
        if(n%7!=0){
            result+="Plong";
            flag=false;
        }
        if(flag){
            result=std::to_string(n);
        }
        return result;
        
    }
}  // namespace raindrops
