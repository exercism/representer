"""Functions used in preparing Guido's gorgeous lasagna.

Learn about Guido, the creator of the Python language: https://en.wikipedia.org/wiki/Guido_van_Rossum
"""
placeholder_0 = 40
placeholder_1 = 2

def placeholder_2(placeholder_3):
    """Calculate the bake time remaining.

    :param elapsed_bake_time: int - baking time already elapsed.
    :return: int - remaining bake time (in minutes) derived from 'EXPECTED_BAKE_TIME'.

    Function that takes the actual minutes the lasagna has been in the oven as
    an argument and returns how many minutes the lasagna still needs to bake
    based on the `EXPECTED_BAKE_TIME`.
    """
    return placeholder_0 - placeholder_3

def placeholder_4(placeholder_5):
    """Calculate the preparation time.

    :param number_of_layers: int - the number of lasagna layers made.
    :return: int - amount of prep time (in minutes), based on 2 minutes per layer added.

    This function takes an integer representing the number of layers added to the dish,
    calculating preparation time using a time of 2 minutes per layer added.
    """
    return placeholder_5 * placeholder_1

def placeholder_6(placeholder_5, placeholder_3):
    """Calculate the elapsed time.

    :param number_of_layers: int - the number of layers in the lasagna.
    :param elapsed_bake_time: int - elapsed cooking time.
    :return: int - total time elapsed (in in minutes) preparing and cooking.

    This function takes two integers representing the number of lasagna layers and the
    time already spent baking and calculates the total elapsed minutes spent cooking the
    lasagna.
    """
    return placeholder_4(placeholder_5) + placeholder_3
