class placeholder_0:

    @staticmethod
    def placeholder_1(placeholder_2):
        return placeholder_0(dict(placeholder_2), [])

    def __init__(self, placeholder_2, placeholder_4):
        self.placeholder_2 = placeholder_2
        self.placeholder_4 = placeholder_4

    def placeholder_5(self):
        return self.placeholder_2['value']

    def placeholder_6(self, placeholder_5):
        self.placeholder_2['value'] = placeholder_5
        return self

    def placeholder_7(self):
        if self.placeholder_2['left'] is None:
            return None
        return placeholder_0(self.placeholder_2['left'], self.placeholder_4 + [self.placeholder_2])

    def placeholder_8(self, placeholder_2):
        self.placeholder_2['left'] = placeholder_2
        return self

    def placeholder_9(self):
        if self.placeholder_2['right'] is None:
            return None
        return placeholder_0(self.placeholder_2['right'], self.placeholder_4 + [self.placeholder_2])

    def placeholder_10(self, placeholder_2):
        self.placeholder_2['right'] = placeholder_2
        return self

    def placeholder_11(self):
        if not self.placeholder_4:
            return None
        return placeholder_0(self.placeholder_4[-1], self.placeholder_4[:-1])

    def placeholder_12(self):
        if any(self.placeholder_4):
            return self.placeholder_4[0]
        return self.placeholder_2
