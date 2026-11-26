#pragma once

#include <string>
#include <vector>

using ingredients = std::vector<std::string>;

namespace lasagna_master {

struct amount {
    int noodles;
    double sauce;
};

int preparationTime(const ingredients &layers, int average_time = 2);
struct amount quantities(const ingredients &layers);
void addSecretIngredient(ingredients &my_list, const ingredients &friends_list);
void addSecretIngredient(ingredients &my_list, const std::string &secret);
std::vector<double> scaleRecipe(const std::vector<double> quantities, int servings);

}  // namespace lasagna_master
