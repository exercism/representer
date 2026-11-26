#include "lasagna_master.h"

namespace lasagna_master {

// TODO: add your solution here

int preparationTime(std::vector<std::string> layers, int time){
    return layers.size() * time;
}
amount quantities(std::vector<std::string> layers){
    amount need{0,0};
    for(const auto& layer : layers){
        if(layer == "noodles"){
            need.noodles += 50;
        }
        else if(layer == "sauce"){
            need.sauce += 0.2;
        }
    }
    return need;
}

void addSecretIngredient(std::vector<std::string>& myList,  const std::vector<std::string>& friendsList){
    if(!myList.empty() && !friendsList.empty()){
        myList.back() = friendsList.back();   
    }
}
void addSecretIngredient(std::vector<std::string>& myList, const std::string& secretIngredient){
    myList.back() = secretIngredient;
}

std::vector<double> scaleRecipe(const std::vector<double>& quantities, int num){
    std::vector<double> scaled;
    for(auto amount:quantities){
        scaled.push_back(amount * (num/2.0));
    }
    return scaled;
}
}  // namespace lasagna_master
