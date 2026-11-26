#include "trinary.h"

namespace trinary {

// TODO: add your solution here
    int to_decimal(std::string trinumber){
        int p = trinumber.length()-1;
        int sum = 0;
        for(int i=0; (unsigned) i<trinumber.length(); i++){
            if((trinumber[i] - '0')>9 || (trinumber[i] - '0')<0){
                return 0;
            }
            sum += (trinumber[i] - '0') * pow(3, p);
            p--;
        }
        return sum;
    }
}  // namespace trinary
