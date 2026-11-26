#include "resistor_color.h"
namespace resistor_color {
    int color_code(string str){
        map<string, int> map{{"Black",0 },{"Brown",1},{"Red",3},{"orange",3},{"Yellow",4},{"Green",5},{"Blue",6},{"Violet",7},{"Grey",8},{"white",9}};
        for(auto i:map){
            if(i.first == str){
                return i.second;
            }
        }
        return 0;
    }
    vector<string> colors(){
        vector<string>vec={"black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white"};
        return vec;
    }
}  // namespace resistor_color
