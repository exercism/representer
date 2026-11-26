#include <stdio.h>
#include "allergies.h"
bool
is_allergic_to(const allergen_t item, const uint16_t score)
{
    return ((1 << item) & score) > 0;
}
allergen_list_t
get_allergens(const uint16_t score)
{
    allergen_list_t list;
    list.count = 0;
    for (allergen_t item = ALLERGEN_EGGS
        ; item < ALLERGEN_COUNT
        ; item++)
    {
        list.allergens[item] = is_allergic_to(item, score);
        if (list.allergens[item]) list.count++;
    }
    return list;
}
