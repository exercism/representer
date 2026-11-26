#include "phone_number.h"
#include <algorithm>
#include <string>
#include <utility>
#include <stdexcept>

namespace phone_number {
    phone_number::phone_number(std::string&& num) : phone_num{num} {
        //Use the number() method.
        const std::string phone_num_digits{number()};
        auto it{phone_num_digits.cbegin()};
        size_t amount_of_digits{phone_num_digits.size()};

        //Check if phone number is of correct size.
        if (amount_of_digits != 10 && amount_of_digits != 11) throw std::domain_error("Phone number must be 10 digits, or 11 digits including a country code.");
        if (amount_of_digits == 11) {
            if(*it != '1') throw std::domain_error("Country code must be 1");
            ++it;
        }

        //Check if the area code is valid.
        if(*it-'0'<2) throw std::domain_error("First digit of country code must be in range 2-9");
        it += 3;
        //Check if local number is valid.
        if(*it-'0'<2) throw std::domain_error("First digit local number must be in range 2-9");

    };
    std::string phone_number::number() const{
        //To maintain integrity of original input, we make a copy of it.
        std::string modified_num{phone_num};
        //Erase everything that is not a number
        auto new_end = std::remove_if(modified_num.begin(), modified_num.end(), [](unsigned char x) {return !isdigit(x);});
        modified_num.erase(new_end, modified_num.end());
        //If there is a starting 1 and the number is 11 digits, remove it since it is redundant.
        if(modified_num.size()==11 && modified_num.front() == '1') modified_num.erase(modified_num.cbegin());
        return modified_num;
    }
    std::string phone_number::area_code() const{return number().substr(0, 3);}
    phone_number::operator std::string() const{
        //Maintain integrity of original input.
        std::string modified_num{phone_num};
        //Delete all preleading whitespace.
        auto it = modified_num.cbegin();
        auto delete_space = [&](){
            while (isspace(*it)){
                modified_num.erase(it);
                ++it;
            }
            };
        
        //Delete all of the whitespace.
        modified_num.erase(modified_num.cbegin(), it);
        //Now delete the +1.
        modified_num.erase(modified_num.cbegin(), modified_num.cbegin()+2);
        //And now delete the whitespace remaining
        delete_space();
        return modified_num;
        
    }
}  // namespace phone_number
