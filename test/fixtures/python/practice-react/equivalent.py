class placeholder_0:

    def __init__(self):
        self.placeholder_2 = []
        self.placeholder_3 = None
        self.placeholder_4 = 0

    def placeholder_5(self, placeholder_6):
        self.placeholder_2.append(placeholder_6)

    @property
    def placeholder_7(self):
        return self.placeholder_3

    @placeholder_7.setter
    def placeholder_7(self, placeholder_8):
        self.placeholder_3 = placeholder_8
        self.placeholder_4 += 1
        for placeholder_6 in self.placeholder_2:
            placeholder_6.placeholder_18()

class placeholder_9(placeholder_0):

    def __init__(self, placeholder_10):
        super().__init__()
        self.placeholder_3 = placeholder_10

class placeholder_11(placeholder_0):

    def __init__(self, placeholder_12, placeholder_13):
        super().__init__()
        self.placeholder_12 = placeholder_12
        self.placeholder_14 = placeholder_13
        self.placeholder_15 = set()
        self.placeholder_18()
        self.placeholder_16()

    def placeholder_16(self):
        for placeholder_17 in self.placeholder_12:
            placeholder_17.placeholder_5(self)

    def placeholder_18(self):
        if len({placeholder_17.placeholder_4 for placeholder_17 in self.placeholder_12}) > 1:
            return
        placeholder_19 = self.placeholder_14([placeholder_17.placeholder_7 for placeholder_17 in self.placeholder_12])
        if placeholder_19 != self.placeholder_3:
            self.placeholder_7 = placeholder_19
            for placeholder_20 in self.placeholder_15:
                placeholder_20(placeholder_19)

    def placeholder_21(self, placeholder_22):
        self.placeholder_15.add(placeholder_22)

    def placeholder_23(self, placeholder_22):
        if placeholder_22 in self.placeholder_15:
            self.placeholder_15.remove(placeholder_22)
