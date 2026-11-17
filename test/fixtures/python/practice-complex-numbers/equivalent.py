import math

class placeholder_0:

    def __init__(self, placeholder_2=0, placeholder_3=0):
        self.placeholder_2 = placeholder_2
        self.placeholder_3 = placeholder_3

    def __eq__(self, placeholder_5):
        if not isinstance(placeholder_5, placeholder_0):
            placeholder_5 = placeholder_0(placeholder_5)
        return self.placeholder_2 == placeholder_5.placeholder_2 and self.placeholder_3 == placeholder_5.placeholder_3

    def __add__(self, placeholder_5):
        if not isinstance(placeholder_5, placeholder_0):
            placeholder_5 = placeholder_0(placeholder_5)
        placeholder_7 = self.placeholder_2 + placeholder_5.placeholder_2
        placeholder_8 = self.placeholder_3 + placeholder_5.placeholder_3
        return placeholder_0(placeholder_7, placeholder_8)

    def __radd__(self, placeholder_5):
        if not isinstance(placeholder_5, placeholder_0):
            placeholder_5 = placeholder_0(placeholder_5)
        placeholder_7 = self.placeholder_2 + placeholder_5.placeholder_2
        placeholder_8 = self.placeholder_3 + placeholder_5.placeholder_3
        return placeholder_0(placeholder_7, placeholder_8)

    def __mul__(self, placeholder_5):
        if not isinstance(placeholder_5, placeholder_0):
            placeholder_5 = placeholder_0(placeholder_5)
        placeholder_7 = self.placeholder_2 * placeholder_5.placeholder_2 - self.placeholder_3 * placeholder_5.placeholder_3
        placeholder_8 = self.placeholder_2 * placeholder_5.placeholder_3 + self.placeholder_3 * placeholder_5.placeholder_2
        return placeholder_0(placeholder_7, placeholder_8)

    def __rmul__(self, placeholder_5):
        if not isinstance(placeholder_5, placeholder_0):
            placeholder_5 = placeholder_0(placeholder_5)
        placeholder_7 = self.placeholder_2 * placeholder_5.placeholder_2 - self.placeholder_3 * placeholder_5.placeholder_3
        placeholder_8 = self.placeholder_2 * placeholder_5.placeholder_3 + self.placeholder_3 * placeholder_5.placeholder_2
        return placeholder_0(placeholder_7, placeholder_8)

    def __sub__(self, placeholder_5):
        if not isinstance(placeholder_5, placeholder_0):
            placeholder_5 = placeholder_0(placeholder_5)
        placeholder_7 = self.placeholder_2 - placeholder_5.placeholder_2
        placeholder_8 = self.placeholder_3 - placeholder_5.placeholder_3
        return placeholder_0(placeholder_7, placeholder_8)

    def __rsub__(self, placeholder_5):
        if not isinstance(placeholder_5, placeholder_0):
            placeholder_5 = placeholder_0(placeholder_5)
        placeholder_7 = placeholder_5.placeholder_2 - self.placeholder_2
        placeholder_8 = placeholder_5.placeholder_3 - self.placeholder_3
        return placeholder_0(placeholder_7, placeholder_8)

    def __truediv__(self, placeholder_5):
        if not isinstance(placeholder_5, placeholder_0):
            placeholder_5 = placeholder_0(placeholder_5)
        placeholder_15 = placeholder_5.conjugate()
        placeholder_16 = placeholder_5 * placeholder_15
        placeholder_17 = placeholder_16.placeholder_2
        placeholder_18 = self * placeholder_15
        return placeholder_0(placeholder_18.placeholder_2 / placeholder_17, placeholder_18.placeholder_3 / placeholder_17)

    def __rtruediv__(self, placeholder_5):
        if not isinstance(placeholder_5, placeholder_0):
            placeholder_5 = placeholder_0(placeholder_5)
        placeholder_15 = self.conjugate()
        placeholder_16 = self * placeholder_15
        placeholder_17 = float(placeholder_16.placeholder_2)
        placeholder_18 = placeholder_5 * placeholder_15
        return placeholder_0(placeholder_18.placeholder_2 / placeholder_17, placeholder_18.placeholder_3 / placeholder_17)

    def __abs__(self):
        placeholder_21 = self.placeholder_2 * self.placeholder_2 + self.placeholder_3 * self.placeholder_3
        return math.sqrt(placeholder_21)

    def conjugate(self):
        return placeholder_0(self.placeholder_2, -1 * self.placeholder_3)

    def exp(self):
        placeholder_7 = math.cos(self.placeholder_3) * math.exp(self.placeholder_2)
        placeholder_8 = math.sin(self.placeholder_3) * math.exp(self.placeholder_2)
        return placeholder_0(placeholder_7, placeholder_8)
