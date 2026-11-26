#include "lasagna_master.h"
#include <algorithm>
namespace lasagna_master {
int
preparationTime(const ingredients &layers, int average_time)
{
    return layers.size() * average_time;
}
struct amount
quantities(const ingredients &layers) {
    int noodles = 0;
    double sauce = 0.0;
    for (auto &layer: layers) {
        if (layer == "noodles") {
            noodles += 50;
        } else if (layer == "sauce") {
            sauce += 0.2;
        }
    }
    struct amount result {noodles, sauce};
    return result;
}
void
addSecretIngredient(ingredients &my_list, const ingredients &friends_list)
{
    my_list.back() = friends_list.back();
}
void
addSecretIngredient(ingredients &my_list, const std::string &secret)
{
    my_list.back() = secret;
}
std::vector<double>
scaleRecipe(const std::vector<double> quantities, int servings)
{
    double scale = servings / 2.0;
    std::vector<double> out(quantities.size());
    std::transform(quantities.begin(), quantities.end(), out.begin(),
                   [scale](double q){ return scale * q;});
    return out;
}
}  // namespace lasagna_master