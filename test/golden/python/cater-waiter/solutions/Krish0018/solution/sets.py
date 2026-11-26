"""Functions for compiling dishes and ingredients for a catering company."""


from sets_categories_data import (VEGAN,
                                  VEGETARIAN,
                                  KETO,
                                  PALEO,
                                  OMNIVORE,
                                  ALCOHOLS,
                                  SPECIAL_INGREDIENTS)


def clean_ingredients(dish_name, dish_ingredients):
    return (dish_name,set(dish_ingredients))

def check_drinks(drink_name, drink_ingredients):
    if any(True for i in drink_ingredients if i in ALCOHOLS):
        return drink_name + " Cocktail"
    return drink_name + " Mocktail"

def categorize_dish(dish_name, dish_ingredients):
    for v, name in ((VEGAN, "VEGAN"),
                    (VEGETARIAN, "VEGETARIAN"),
                    (PALEO, "PALEO"),
                    (KETO, "KETO"),
                    (OMNIVORE, "OMNIVORE")):
        if set(dish_ingredients) <= set(v):
            return f"{dish_name}: {name}"

def tag_special_ingredients(dish):
    dish_name, ingredients = dish
    if allergens := SPECIAL_INGREDIENTS.intersection(set(ingredients)):
        return dish_name, allergens

def compile_ingredients(dishes):
    return set.union(*dishes)

def separate_appetizers(dishes, appetizers):
    return list(set(dishes) - set(appetizers))

def singleton_ingredients(dishes, intersection):
    singletons = (dish - intersection for dish in dishes)
    return set.union(*singletons)
