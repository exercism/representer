"""Functions to help Azara and Rui locate pirate treasure."""

def placeholder_0(placeholder_1):
    """Return coordinate value from a tuple containing the treasure name, and treasure coordinate.

    :param record: tuple - with a (treasure, coordinate) pair.
    :return: str - the extracted map coordinate.
    """
    return placeholder_1[1]

def placeholder_2(placeholder_3):
    """Split the given coordinate into tuple containing its individual components.

    :param coordinate: str - a string map coordinate
    :return: tuple - the string coordinate split into its individual components.
    """
    return tuple(placeholder_3)

def placeholder_4(placeholder_5, placeholder_6):
    """Compare two record types and determine if their coordinates match.

    :param azara_record: tuple - a (treasure, coordinate) pair.
    :param rui_record: tuple - a (location, tuple(coordinate_1, coordinate_2), quadrant) trio.
    :return: bool - do the coordinates match?
    """
    return placeholder_2(placeholder_5[1]) in placeholder_6

def placeholder_7(placeholder_5, placeholder_6):
    """Combine the two record types (if possible) and create a combined record group.

    :param azara_record: tuple - a (treasure, coordinate) pair.
    :param rui_record: tuple - a (location, coordinate, quadrant) trio.
    :return: tuple or str - the combined record (if compatible), or the string "not a match" (if incompatible).
    """
    placeholder_8 = 'not a match'
    if placeholder_4(placeholder_5, placeholder_6):
        placeholder_8 = placeholder_5 + placeholder_6
    return placeholder_8

def placeholder_9(placeholder_10):
    """Clean up a combined record group into a multi-line string of single records.

    :param combined_record_group: tuple - everything from both participants.
    :return: str - everything "cleaned", excess coordinates and information are removed.

    The return statement should be a multi-lined string with items separated by newlines.

    (see HINTS.md for an example).
    """
    placeholder_11 = ''
    for placeholder_12 in placeholder_10:
        placeholder_11 += f'{(placeholder_12[0], placeholder_12[2], placeholder_12[3], placeholder_12[4])}\n'
    return placeholder_11
