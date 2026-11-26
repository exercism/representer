#include "roman_numerals.h"
#include <string>
namespace roman_numerals {
    std::string convert(int number){
        std::string roman_num;
        while (number != 0){
            if (number > 1000){
                number -= 1000;
                roman_num += "M";
            }
            else if (number >= 900){
                number -= 900;
                roman_num += "CM";
            }
            else if (number >= 500){
                number -= 500;
                roman_num += "D";
            }
            else if (number >= 400){
                number -= 400;
                roman_num += "CD";
            }
            else if (number >= 100){
                number -= 100;
                roman_num += "C";
            }
            else if (number >= 90){
                number -= 90;
                roman_num += "XC";
            }
            else if (number >= 50){
                number -= 50;
                roman_num += "L";
            }
            else if (number >= 40){
                number -= 40;
                roman_num += "XL";
            }
            else if (number >= 10){
                number -= 10;
                roman_num += "X";
            }
            else if (number >= 9){
                number -= 9;
                roman_num += "IX";
            }
            else if (number >= 5){
                number -= 5;
                roman_num += "V";
            }
            else if (number >= 4){
                number -= 4;
                roman_num += "IV";
            }
            else{
                number -= 1;
                roman_num += "I";
            }
        }
        return roman_num;        
    }
} 
