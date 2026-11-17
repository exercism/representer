placeholder_0, placeholder_1, placeholder_2, placeholder_3 = range(4)

class placeholder_4:
    placeholder_5 = [placeholder_0, placeholder_1, placeholder_2, placeholder_3]

    def __init__(self, placeholder_7=placeholder_0):
        self.placeholder_7 = placeholder_7

    def placeholder_8(self):
        self.placeholder_7 = self.placeholder_5[self.placeholder_7 - 1]

    def placeholder_9(self):
        self.placeholder_7 = self.placeholder_5[(self.placeholder_7 + 1) % 4]

class placeholder_10:

    def __init__(self, placeholder_7=placeholder_0, placeholder_11=0, placeholder_12=0):
        self.placeholder_5 = placeholder_4(placeholder_7)
        self.placeholder_11 = placeholder_11
        self.placeholder_12 = placeholder_12

    def placeholder_13(self):
        if self.placeholder_7 == placeholder_0:
            self.placeholder_12 += 1
        elif self.placeholder_7 == placeholder_2:
            self.placeholder_12 -= 1
        elif self.placeholder_7 == placeholder_1:
            self.placeholder_11 += 1
        elif self.placeholder_7 == placeholder_3:
            self.placeholder_11 -= 1

    def placeholder_14(self):
        self.placeholder_5.placeholder_8()

    def placeholder_15(self):
        self.placeholder_5.placeholder_9()

    def placeholder_16(self, placeholder_17):
        placeholder_18 = {'A': self.placeholder_13, 'R': self.placeholder_15, 'L': self.placeholder_14}
        for placeholder_19 in placeholder_17:
            if placeholder_19 in placeholder_18:
                placeholder_18[placeholder_19]()

    @property
    def placeholder_7(self):
        return self.placeholder_5.placeholder_7

    @property
    def placeholder_20(self):
        return (self.placeholder_11, self.placeholder_12)
