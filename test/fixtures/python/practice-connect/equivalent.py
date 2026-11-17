class placeholder_0:
    placeholder_1 = [(0, 1), (0, -1), (1, 0), (-1, 0), (1, -1), (-1, 1)]
    placeholder_2 = 'O'
    placeholder_3 = 'X'

    def __init__(self, placeholder_5):
        self.placeholder_6 = placeholder_0.placeholder_11(placeholder_5)
        assert len(self.placeholder_6) > 0
        self.placeholder_7 = len(self.placeholder_6[0])
        self.placeholder_8 = len(self.placeholder_6)
        assert self.placeholder_7 > 0 and self.placeholder_8 > 0
        for placeholder_9 in self.placeholder_6:
            assert len(placeholder_9) == self.placeholder_7

    def placeholder_10(self, placeholder_7, placeholder_8):
        return 0 <= placeholder_7 < self.placeholder_7 and 0 <= placeholder_8 < self.placeholder_8

    @staticmethod
    def placeholder_11(placeholder_5):
        return [''.join(placeholder_12.split()) for placeholder_12 in placeholder_5.splitlines()]

    def placeholder_13(self, placeholder_14, placeholder_7, placeholder_8):
        if placeholder_14 == self.placeholder_3:
            return placeholder_7 == self.placeholder_7 - 1
        if placeholder_14 == self.placeholder_2:
            return placeholder_8 == self.placeholder_8 - 1
        return None

    def placeholder_15(self, placeholder_14, placeholder_7, placeholder_8, placeholder_16=None):
        if not placeholder_16:
            placeholder_16 = []
        if (placeholder_7, placeholder_8) in placeholder_16:
            return False
        if not self.placeholder_10(placeholder_7, placeholder_8) or self.placeholder_6[placeholder_8][placeholder_7] != placeholder_14:
            return False
        if self.placeholder_13(placeholder_14, placeholder_7, placeholder_8):
            return True
        for placeholder_17 in self.placeholder_1:
            if self.placeholder_15(placeholder_14, placeholder_7 + placeholder_17[0], placeholder_8 + placeholder_17[1], placeholder_16 + [(placeholder_7, placeholder_8)]):
                return True
        return None

    def placeholder_18(self, placeholder_14):
        if placeholder_14 == self.placeholder_3:
            for placeholder_8 in range(self.placeholder_8):
                if self.placeholder_15(placeholder_14, 0, placeholder_8):
                    return True
        if placeholder_14 == self.placeholder_2:
            for placeholder_7 in range(self.placeholder_7):
                if self.placeholder_15(placeholder_14, placeholder_7, 0):
                    return True
        return None

    def placeholder_19(self):
        if self.placeholder_18(self.placeholder_3):
            return self.placeholder_3
        if self.placeholder_18(self.placeholder_2):
            return self.placeholder_2
        return ''
