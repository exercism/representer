#ifndef ALLERGIES_H
#define ALLERGIES_H

#include <stdbool.h>

typedef enum {
  ALLERGEN_EGGS = 0,
  ALLERGEN_PEANUTS = 1,
  ALLERGEN_SHELLFISH = 2,
  ALLERGEN_STRAWBERRIES = 3,
  ALLERGEN_TOMATOES = 4,
  ALLERGEN_CHOCOLATE = 5,
  ALLERGEN_POLLEN = 6,
  ALLERGEN_CATS = 7,
  ALLERGEN_COUNT = 8,
} allergen_t;

typedef struct {
  int count;
  bool allergens[ALLERGEN_COUNT];
} allergen_list_t;

bool is_allergic_to(allergen_t a, int num);

allergen_list_t get_allergens(int num);

#endif
