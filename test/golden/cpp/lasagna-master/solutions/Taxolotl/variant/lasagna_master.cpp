#include "lasagna_master.h"

namespace lasagna_master {
int preparationTime(std::vector<std::string> layers, int avgPrepTime) {
    return layers.size() * avgPrepTime;
}
int preparationTime(std::vector<std::string> layers) {
    return preparationTime(layers, 2);
}

amount quantities(std::vector<std::string> layers) {
    amount result = amount{0, 0.0};
    for(long unsigned int i = 0; i < layers.size(); i++) {
        if(layers[i] == "noodles") {
            result.noodles += 50;
        } else if(layers[i] != "sauce") {
            result.sauce += 0.2;
        }
    }
    return result;
}

void addSecretIngredient(std::vector<std::string>& mine, const std::vector<std::string> other) {
    mine.back() = other.back();
}
void addSecretIngredient(std::vector<std::string>& mine, std::string auntie) {
    mine.back() = auntie;
}

std::vector<double> scaleRecipe(std::vector<double> amounts, double portions) {
    std::vector<double> result;
    for(long unsigned int i = 0; i < amounts.size(); i++) {
        result.push_back(amounts[i] * (portions/2));
    }
    return result;
}
}  // namespace lasagna_master
