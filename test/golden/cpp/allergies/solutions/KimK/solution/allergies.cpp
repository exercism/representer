#include "allergies.h"
#include <string>
#include <unordered_set>
#include <map>

namespace allergies 
{
    const std::map<std::string, int> allergy_test::allergy_map = 
            {{"eggs",         1},
            {"peanuts",      2},
            {"shellfish",    4},
            {"strawberries", 8},
            {"tomatoes",     16},
            {"chocolate",    32},
            {"pollen",       64},
            {"cats",         128}};

    allergy_test::allergy_test(int score) 
    {
        for(auto i : allergy_map)
            {
                if((i.second & score) != 0)
                    allergies.insert(i.first);
            }
    }
    bool allergy_test::is_allergic_to(std::string allergen)
    {
        return allergies.find(allergen) != allergies.end();
    }
    std::unordered_set<std::string> allergy_test::get_allergies() 
    {
        return allergies; 
    }
    
}  // namespace allergies
