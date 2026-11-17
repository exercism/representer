placeholder_0 = 10

class placeholder_1:

    def __init__(self, placeholder_3):
        self.placeholder_3 = placeholder_3
        self.placeholder_4 = []

    @property
    def placeholder_5(self):
        """Total pins knocked down in a frame."""
        return sum(self.placeholder_4)

    def placeholder_6(self):
        return self.placeholder_5 == 10 and len(self.placeholder_4) == 1

    def placeholder_7(self):
        return self.placeholder_5 == 10 and len(self.placeholder_4) == 2

    def placeholder_8(self):
        return self.placeholder_5 < 10 and len(self.placeholder_4) == 2

    def placeholder_9(self):
        """Return whether a frame is over."""
        return self.placeholder_5 == 10 or len(self.placeholder_4) == 2

    def throw(self, placeholder_11):
        if self.placeholder_5 + placeholder_11 > 10:
            raise ValueError("a frame's rolls cannot exceed 10")
        self.placeholder_4.append(placeholder_11)

    def placeholder_12(self, placeholder_13):
        placeholder_14 = self.placeholder_5
        if self.placeholder_6():
            placeholder_14 += sum(placeholder_13[:2])
        elif self.placeholder_7():
            placeholder_14 += sum(placeholder_13[:1])
        return placeholder_14

class placeholder_15:

    def __init__(self):
        self.placeholder_16 = 0
        self.placeholder_17 = []
        self.placeholder_18 = [placeholder_1(placeholder_3) for placeholder_3 in range(placeholder_0)]

    @property
    def placeholder_19(self):
        return self.placeholder_18[self.placeholder_16]

    def placeholder_13(self, placeholder_20):
        """Return a frame's next throws in the form of a list."""
        placeholder_4 = []
        for placeholder_3 in range(placeholder_20 + 1, placeholder_0):
            placeholder_4.extend(self.placeholder_18[placeholder_3].placeholder_4)
        placeholder_4.extend(self.placeholder_17)
        return placeholder_4

    def placeholder_21(self, placeholder_11):
        placeholder_22 = self.placeholder_18[-1]
        if placeholder_22.placeholder_8():
            raise IndexError('cannot throw bonus with an open tenth frame')
        self.placeholder_17.append(placeholder_11)
        if len(self.placeholder_17) == 2 and self.placeholder_17[0] != 10 and (sum(self.placeholder_17) > 10):
            raise ValueError('invalid fill balls')
        if placeholder_22.placeholder_6() and len(self.placeholder_17) > 2:
            raise IndexError('wrong number of fill balls when the tenth frame is a strike')
        elif placeholder_22.placeholder_7() and len(self.placeholder_17) > 1:
            raise IndexError('wrong number of fill balls when the tenth frame is a spare')

    def placeholder_23(self, placeholder_11):
        if not 0 <= placeholder_11 <= 10:
            raise ValueError('invalid pins')
        elif self.placeholder_16 == placeholder_0:
            self.placeholder_21(placeholder_11)
        else:
            self.placeholder_19.throw(placeholder_11)
            if self.placeholder_19.placeholder_9():
                self.placeholder_16 += 1

    def placeholder_12(self):
        if self.placeholder_16 < placeholder_0:
            raise IndexError('frame less than 10')
        if self.placeholder_18[-1].placeholder_7() and len(self.placeholder_17) != 1:
            raise IndexError('one bonus must be rolled when the tenth frame is spare')
        if self.placeholder_18[-1].placeholder_6() and len(self.placeholder_17) != 2:
            raise IndexError('two bonuses must be rolled when the tenth frame is strike')
        return sum((placeholder_24.placeholder_12(self.placeholder_13(placeholder_24.placeholder_3)) for placeholder_24 in self.placeholder_18))
