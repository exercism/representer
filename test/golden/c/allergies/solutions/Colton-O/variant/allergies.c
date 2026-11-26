#include "allergies.h"

bool is_allergic_to(allergen_t a, int num) {
  allergen_list_t allergens = get_allergens(num);
  return (allergens.allergens[a]);
}

allergen_list_t get_allergens(int num) {
  // set up count and list
  allergen_list_t allergens_list;
  allergens_list.count = 0;

  // cursor number for tracking allergies outside list
  int outside_allergen_num = 1;
  // check for allergies outside of list
  while (num > 256) {
    while (outside_allergen_num < num) {
      outside_allergen_num <<= 1;
    }
    outside_allergen_num >>= 1;
    num -= outside_allergen_num;
  }

  // Check for allergies inside list
  for (int i = ALLERGEN_COUNT + 1; i >= 0; i--) {
    allergens_list.allergens[i] = false;
    if (num >= 1 << i) {
      allergens_list.allergens[i] = true;
      allergens_list.count++;
      num -= 1 << i;
    }
  }

  return allergens_list;
}
