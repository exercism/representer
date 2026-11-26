#include "etl.h"

#include <cctype>
#include <iostream>
#include <map>
#include <string>
#include <vector>
namespace etl
{
std::map<char, int> transform(std::map<int, std::vector<char>> old)
{
    std::map<char, int> actual{};
    for (const auto &pair : old)
    {
        for (const auto &letter : pair.second)
        {
            actual[std::tolower(letter)] = pair.first;
            std::cout << "Key: " << letter - 32 << ", Value: " << pair.first << std::endl;
        }
    }
    return actual;
}
} // namespace etl

// int main()
// {
//     const std::map<int, std::vector<char>> old{{1, {'A'}}};
//     const auto actual = etl::transform(old);
//     const std::map<char, int> expected{{'a', 1}};

//     return 0;
// }