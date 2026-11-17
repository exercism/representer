"""Functions for compiling dishes and ingredients for a catering company."""
from sets_categories_data import VEGAN, VEGETARIAN, KETO, PALEO, OMNIVORE, ALCOHOLS, SPECIAL_INGREDIENTS

def placeholder_0(placeholder_1, placeholder_2):
    """Remove duplicates from `dish_ingredients`.

    :param dish_name: str - containing the dish name.
    :param dish_ingredients: list - dish ingredients.
    :return: tuple - containing (dish_name, ingredient set).

    This function should return a `tuple` with the name of the dish as the first item,
    followed by the de-duped `set` of ingredients as the second item.
    """
    return (placeholder_1, set(placeholder_2))

def placeholder_3(placeholder_4, placeholder_5):
    """Append "Cocktail" (alcohol)  or "Mocktail" (no alcohol) to `drink_name`, based on `drink_ingredients`.

    :param drink_name: str - name of the drink.
    :param drink_ingredients: list - ingredients in the drink.
    :return: str - drink_name appended with "Mocktail" or "Cocktail".

    The function should return the name of the drink followed by "Mocktail" (non-alcoholic) and drink
    name followed by "Cocktail" (includes alcohol).
    """
    if not ALCOHOLS.isdisjoint(placeholder_5):
        return placeholder_4 + ' Cocktail'
    return placeholder_4 + ' Mocktail'

def placeholder_6(placeholder_1, placeholder_2):
    """Categorize `dish_name` based on `dish_ingredients`.

    :param dish_name: str - dish to be categorized.
    :param dish_ingredients: list - ingredients for the dish.
    :return: str - the dish name appended with ": <CATEGORY>".

    This function should return a string with the `dish name: <CATEGORY>` (which meal category the dish belongs to).
    `<CATEGORY>` can be any one of  (VEGAN, VEGETARIAN, PALEO, KETO, or OMNIVORE).
    All dishes will "fit" into one of the categories imported from `sets_categories_data.py`

    """
    placeholder_7 = ((VEGAN, 'VEGAN'), (VEGETARIAN, 'VEGETARIAN'), (KETO, 'KETO'), (PALEO, 'PALEO'), (OMNIVORE, 'OMNIVORE'))
    for placeholder_8 in placeholder_7:
        if set(placeholder_2) <= placeholder_8[0]:
            return placeholder_1 + ': ' + placeholder_8[1]
    return None

def placeholder_9(placeholder_10):
    """Compare `dish` ingredients to `SPECIAL_INGREDIENTS`.

    :param dish: tuple - of (dish name, list of dish ingredients).
    :return: tuple - containing (dish name, dish special ingredients).

    Return the dish name followed by the `set` of ingredients that require a special note on the dish description.
    For the purposes of this exercise, all allergens or special ingredients that need to be tracked are in the
    SPECIAL_INGREDIENTS constant imported from `sets_categories_data.py`.
    """
    return (placeholder_10[0], SPECIAL_INGREDIENTS & set(placeholder_10[1]))

def placeholder_11(placeholder_12):
    """Create a master list of ingredients.

    :param dishes: list - of dish ingredient sets.
    :return: set - of ingredients compiled from `dishes`.

    This function should return a `set` of all ingredients from all listed dishes.
    """
    placeholder_13 = set()
    for placeholder_14 in placeholder_12:
        placeholder_13 = placeholder_13.union(placeholder_14)
    return placeholder_13

def placeholder_15(placeholder_12, placeholder_16):
    """Determine which `dishes` are designated `appetizers` and remove them.

    :param dishes: list - of dish names.
    :param appetizers: list - of appetizer names.
    :return: list - of dish names that do not appear on appetizer list.

    The function should return the list of dish names with appetizer names removed.
    Either list could contain duplicates and may require de-duping.
    """
    return list(set(placeholder_12) - set(placeholder_16))

def placeholder_17(placeholder_12, placeholder_18):
    """Determine which `dishes` have a singleton ingredient (an ingredient that only appears once across dishes).

    :param dishes: list - of ingredient sets.
    :param intersection: constant - can be one of `<CATEGORY>_INTERSECTION` constants imported from `sets_categories_data.py`.
    :return: set - containing singleton ingredients.

    Each dish is represented by a `set` of its ingredients.

    Each `<CATEGORY>_INTERSECTION` is an `intersection` of all dishes in the category. `<CATEGORY>` can be any one of:
        (VEGAN, VEGETARIAN, PALEO, KETO, or OMNIVORE).

    The function should return a `set` of ingredients that only appear in a single dish.
    """
    placeholder_19 = set()
    for placeholder_14 in placeholder_12:
        placeholder_19 = placeholder_19 ^ placeholder_14
    return placeholder_19 - placeholder_18
