def is_isogram(string: str) -> bool:
    """

    :param string: word to evaluate as isogram
    """
    string = string.lower()
    special_characters = [" ", "-"]
    for character in special_characters:
        string = string.replace(character, "")
    return len(string) == len(set(string))
