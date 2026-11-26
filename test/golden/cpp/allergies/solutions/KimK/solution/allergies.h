#if !defined(ALLERGIES_H)
#define ALLERGIES_H
#include <string>
#include <unordered_set>
#include <map>

namespace allergies {

class allergy_test
{
    public:
        allergy_test(int score);
        bool is_allergic_to(std::string allergen);
        std::unordered_set<std::string> get_allergies(); 
        std::unordered_set<std::string> allergies;
    private:
        static const std::map<std::string, int> allergy_map;
};

}  // namespace allergies

#endif // ALLERGIES_H