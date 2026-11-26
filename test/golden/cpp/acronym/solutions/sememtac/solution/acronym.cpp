#include "acronym.h"

using namespace std;
namespace acronym {
std::string acronym(std::string arg)
{
    std::string result{};
    size_t s = arg.size();
    char letter {};
    for (size_t i = 0; i < s; i++)
        {
            if (isalpha(arg[i]))
            {
                letter = toupper(arg[i]);
                if (i == 0)
                {
                    result.push_back(letter);
                }
                else if (isspace(arg[i - 1]) || (arg[i - 1] == DASH || arg[i - 1] == HYPHEN))
                {
                    result.push_back(letter);
                }
            }
        }
    return result;
}
}  // namespace acronym
