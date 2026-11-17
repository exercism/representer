placeholder_0 = 'B'
placeholder_1 = 'W'
placeholder_2 = ''
placeholder_3 = [placeholder_0, placeholder_1]
placeholder_4 = [(0, 1), (0, -1), (1, 0), (-1, 0)]

class placeholder_5:

    def __init__(self, placeholder_7):
        self.placeholder_7 = placeholder_7
        self.placeholder_8 = len(self.placeholder_7[0])
        self.placeholder_9 = len(self.placeholder_7)

    def placeholder_10(self, placeholder_8, placeholder_9):
        return self.placeholder_8 > placeholder_8 >= 0 and self.placeholder_9 > placeholder_9 >= 0

    def placeholder_11(self, placeholder_8, placeholder_9, placeholder_12=None, placeholder_13=None, placeholder_14=None):
        placeholder_12 = [] if placeholder_12 is None else placeholder_12
        placeholder_13 = [] if placeholder_13 is None else placeholder_13
        placeholder_14 = [] if placeholder_14 is None else placeholder_14
        if (placeholder_8, placeholder_9) not in placeholder_13 and self.placeholder_10(placeholder_8, placeholder_9):
            placeholder_15 = self.placeholder_7[placeholder_9][placeholder_8]
            if placeholder_15 in placeholder_3:
                if placeholder_15 not in placeholder_14:
                    return (placeholder_12, placeholder_14 + [placeholder_15])
            else:
                for placeholder_16 in placeholder_4:
                    placeholder_17 = self.placeholder_11(placeholder_8 + placeholder_16[0], placeholder_9 + placeholder_16[1], placeholder_12 + [(placeholder_8, placeholder_9)], placeholder_13 + [(placeholder_8, placeholder_9)], placeholder_14)
                    placeholder_12 = placeholder_17[0]
                    placeholder_14 = placeholder_17[1]
        return (placeholder_12, placeholder_14)

    def placeholder_18(self, placeholder_19, placeholder_20):
        if not self.placeholder_10(placeholder_19, placeholder_20):
            raise ValueError('Invalid coordinate')
        if self.placeholder_7[placeholder_20][placeholder_19] in placeholder_3:
            return (placeholder_2, set())
        placeholder_12, placeholder_14 = self.placeholder_11(placeholder_19, placeholder_20)
        placeholder_21 = set(placeholder_12)
        if len(placeholder_14) == 1:
            return (placeholder_14[0], placeholder_21)
        return (placeholder_2, placeholder_21)

    def placeholder_22(self):
        placeholder_23 = placeholder_3 + [placeholder_2]
        placeholder_21 = {placeholder_24: set() for placeholder_24 in placeholder_23}
        placeholder_17 = set()
        for placeholder_25 in range(self.placeholder_9):
            for placeholder_26 in range(self.placeholder_8):
                if not (placeholder_26, placeholder_25) in placeholder_17:
                    placeholder_24, placeholder_27 = self.placeholder_18(placeholder_26, placeholder_25)
                    placeholder_21[placeholder_24].update(placeholder_27)
                    placeholder_17.update(placeholder_27)
        return placeholder_21
