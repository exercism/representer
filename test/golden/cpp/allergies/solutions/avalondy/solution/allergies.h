#pragma once
#include <array>
#include <string>
#include <string_view>
#include <unordered_set>

namespace allergies {

// TODO: add your solution here
class AllergyList {
public:
  AllergyList(unsigned int x);

  bool is_allergic_to(std::string item);

  std::unordered_set<std::string> get_allergies();

private:
  std::unordered_set<std::string> allergy_set;
  std::array<std::string_view, 8> items = {
      "eggs",     "peanuts",   "shellfish", "strawberries",
      "tomatoes", "chocolate", "pollen",    "cats"};
};
AllergyList allergy_test(unsigned int x);
} // namespace allergies
