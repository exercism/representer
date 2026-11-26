#pragma once
#include <vector>
#include <string>

namespace lasagna_master {

struct amount {
    int noodles;
    double sauce;
};

int preparationTime(std::vector<std::string> layers, int avgPrepTime);
int preparationTime(std::vector<std::string> layers);

amount quantities(std::vector<std::string> layers);

void addSecretIngredient(std::vector<std::string>& mine, const std::vector<std::string> other);
void addSecretIngredient(std::vector<std::string>& mine, std::string auntie);

std::vector<double> scaleRecipe(std::vector<double> amounts, double portions);
}  // namespace lasagna_master
