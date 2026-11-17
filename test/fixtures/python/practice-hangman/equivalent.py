placeholder_0 = 'win'
placeholder_1 = 'lose'
placeholder_2 = 'ongoing'

class placeholder_3:

    def __init__(self, placeholder_5):
        self.placeholder_6 = 9
        self.placeholder_7 = placeholder_2
        self.placeholder_5 = placeholder_5
        self.placeholder_8 = ''
        self.placeholder_9 = []
        for _ in self.placeholder_5:
            self.placeholder_8 += '_'

    def placeholder_11(self, placeholder_12):
        if self.placeholder_7 != placeholder_2:
            raise ValueError('The game has already ended.')
        self.placeholder_15(placeholder_12)
        self.placeholder_13()
        self.placeholder_16()

    def placeholder_13(self):
        self.placeholder_8 = ''
        for placeholder_14 in self.placeholder_5:
            if placeholder_14 not in self.placeholder_9:
                self.placeholder_8 += '_'
            else:
                self.placeholder_8 += placeholder_14

    def placeholder_15(self, placeholder_12):
        if placeholder_12 not in self.placeholder_5 or placeholder_12 in self.placeholder_9:
            self.placeholder_6 -= 1
        else:
            self.placeholder_9.append(placeholder_12)

    def placeholder_16(self):
        if self.placeholder_8 == self.placeholder_5:
            self.placeholder_7 = placeholder_0
        elif self.placeholder_6 < 0:
            self.placeholder_7 = placeholder_1
        else:
            self.placeholder_7 = placeholder_2

    def placeholder_17(self):
        return self.placeholder_8

    def placeholder_18(self):
        return self.placeholder_7
