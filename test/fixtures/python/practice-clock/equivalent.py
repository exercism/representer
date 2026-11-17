class placeholder_0:
    """Clock that displays 24 hour clock that rollsover properly"""

    def __init__(self, placeholder_2, placeholder_3):
        self.placeholder_2 = placeholder_2
        self.placeholder_3 = placeholder_3
        self.placeholder_11()

    def __repr__(self):
        return f'Clock({self.placeholder_2}, {self.placeholder_3})'

    def __str__(self):
        return '{:02d}:{:02d}'.format(self.placeholder_2, self.placeholder_3)

    def __eq__(self, placeholder_7):
        return repr(self) == repr(placeholder_7)

    def __add__(self, placeholder_9):
        self.placeholder_3 += placeholder_9
        return self.placeholder_11()

    def __sub__(self, placeholder_9):
        self.placeholder_3 -= placeholder_9
        return self.placeholder_11()

    def placeholder_11(self):
        self.placeholder_2 += self.placeholder_3 // 60
        self.placeholder_2 %= 24
        self.placeholder_3 %= 60
        return self
