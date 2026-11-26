#ifndef UUID_D8F5A5A5_EA3E_44F7_8755_5D182DA07811
#define UUID_D8F5A5A5_EA3E_44F7_8755_5D182DA07811
#include <vector>
namespace knapsack
{
struct Item
{
    int weight;
    int value;
};
int maximum_value(int max_weight, const std::vector<Item>& items);
} // namespace knapsack
#endif //UUID_D8F5A5A5_EA3E_44F7_8755_5D182DA07811
