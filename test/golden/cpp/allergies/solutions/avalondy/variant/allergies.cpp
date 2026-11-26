#include "allergies.h"
#include <array>
#include <string>
#include <unordered_set>

// TODO: add your solution here
allergies::AllergyList::AllergyList(unsigned int x) {
  allergy_set = std::unordered_set<std::string>();
  for (auto i = 0; i <= 8; i++) {
    if ((x & (1 << i)) > 0) {
      allergy_set.emplace(items[i]);
    }
  }
}

bool allergies::AllergyList::is_allergic_to(std::string item) {
  return allergy_set.find(std::string(item)) != allergy_set.end();
}

std::unordered_set<std::string> allergies::AllergyList::get_allergies() {
  return allergy_set;
}

allergies::AllergyList allergies::allergy_test(unsigned int x) {
  return allergies::AllergyList(x);
}