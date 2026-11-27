from calendar import Calendar

def placeholder_0(placeholder_1, placeholder_2, placeholder_3, placeholder_4):
    placeholder_5 = [placeholder_6 for placeholder_6 in Calendar().itermonthdates(placeholder_1, placeholder_2) if placeholder_6.placeholder_2 == placeholder_2 if placeholder_6.strftime('%A') == placeholder_4]
    return placeholder_7(placeholder_3)(placeholder_5)

def placeholder_7(placeholder_3):
    if placeholder_3 == 'teenth':
        return lambda placeholder_8: next((placeholder_6 for placeholder_6 in placeholder_8 if 13 <= placeholder_6.day <= 19))
    placeholder_9 = ('first', 'second', 'third', 'fourth', 'fifth', 'sixth')
    placeholder_10 = -1 if placeholder_3 == 'last' else placeholder_9.index(placeholder_3)

    def placeholder_11(placeholder_8):
        if placeholder_10 < len(placeholder_8):
            return placeholder_8[placeholder_10]
        raise placeholder_12('That day does not exist.')
    return placeholder_11

class placeholder_12(ValueError):
    """Exception raised when the Meetup weekday and count do not result in a valid date.

    message: explanation of the error.

    """

    def __init__(self, placeholder_14):
        self.placeholder_14 = placeholder_14
