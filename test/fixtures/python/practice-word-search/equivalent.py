import copy

class placeholder_0:

    def __init__(self, placeholder_2, placeholder_3):
        self.placeholder_2 = placeholder_2
        self.placeholder_3 = placeholder_3

    def __repr__(self):
        return f'Point({self.placeholder_2}:{self.placeholder_3})'

    def __add__(self, placeholder_6):
        return placeholder_0(self.placeholder_2 + placeholder_6.placeholder_2, self.placeholder_3 + placeholder_6.placeholder_3)

    def __sub__(self, placeholder_6):
        return placeholder_0(self.placeholder_2 - placeholder_6.placeholder_2, self.placeholder_3 - placeholder_6.placeholder_3)

    def __eq__(self, placeholder_6):
        return self.placeholder_2 == placeholder_6.placeholder_2 and self.placeholder_3 == placeholder_6.placeholder_3

    def __ne__(self, placeholder_6):
        return not self == placeholder_6
placeholder_10 = (placeholder_0(1, 0), placeholder_0(1, -1), placeholder_0(1, 1), placeholder_0(-1, -1), placeholder_0(0, -1), placeholder_0(0, 1), placeholder_0(-1, 1), placeholder_0(-1, 0))

class placeholder_11:

    def __init__(self, placeholder_12):
        self.placeholder_13 = placeholder_12
        self.placeholder_14 = len(self.placeholder_13[0])
        self.placeholder_15 = len(self.placeholder_13)

    def placeholder_16(self, placeholder_17):
        if placeholder_17.placeholder_2 < 0 or placeholder_17.placeholder_2 >= self.placeholder_14:
            return None
        if placeholder_17.placeholder_3 < 0 or placeholder_17.placeholder_3 >= self.placeholder_15:
            return None
        return self.placeholder_13[placeholder_17.placeholder_3][placeholder_17.placeholder_2]

    def find(self, placeholder_19, placeholder_20, placeholder_21):
        placeholder_22 = copy.copy(placeholder_20)
        for placeholder_23 in placeholder_19:
            if self.placeholder_16(placeholder_22) != placeholder_23:
                return None
            placeholder_22 += placeholder_21
        return (placeholder_20, placeholder_22 - placeholder_21)

    def search(self, placeholder_19):
        placeholder_25 = (placeholder_0(placeholder_26, placeholder_27) for placeholder_26 in range(self.placeholder_14) for placeholder_27 in range(self.placeholder_15))
        for placeholder_20 in placeholder_25:
            for placeholder_21 in placeholder_10:
                placeholder_28 = self.find(placeholder_19, placeholder_20, placeholder_21)
                if placeholder_28:
                    return placeholder_28
        return None
