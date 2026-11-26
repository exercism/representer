#include "luhn.h"
#include <string>
#include <algorithm>
namespace luhn {
bool valid(const std::string& credit){
   std::string credit1 = credit;
    credit1.erase(std::remove_if(credit1.begin(), credit1.end(), isspace), credit1.end());
    if(credit1.length()==1)
        return 0;
    int sum =0;
   for (int i= credit1.length() -1;i>=0;i--) {
        if(isdigit(credit1[i]) == false)
        return false;
        }
    bool isSecond = false;
    for (int i= credit1.length() -1;i>=0;i--){
        int temp = credit1.at(i) -'0';
        if (isSecond){
            temp = temp*2;
            if (temp>9)
                temp = temp-9;
        }
        sum = sum + temp;
        isSecond = !isSecond;
    }
    if(sum%10==0)
        return true;
    else
        return false;
}
}  // namespace luhn