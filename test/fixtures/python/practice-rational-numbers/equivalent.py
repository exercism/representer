from math import gcd

class placeholder_0:

    def __init__(self, placeholder_2, placeholder_3):
        placeholder_4 = abs(gcd(placeholder_2, placeholder_3))
        self.placeholder_2 = placeholder_2 // placeholder_4
        self.placeholder_3 = placeholder_3 // placeholder_4
        if self.placeholder_3 < 0:
            self.placeholder_2 *= -1
            self.placeholder_3 *= -1

    def __eq__(self, placeholder_6):
        return self.placeholder_2 == placeholder_6.placeholder_2 and self.placeholder_3 == placeholder_6.placeholder_3

    def __repr__(self):
        return f'{self.placeholder_2}/{self.placeholder_3}'

    def __add__(self, placeholder_6):
        placeholder_2 = self.placeholder_2 * placeholder_6.placeholder_3 + placeholder_6.placeholder_2 * self.placeholder_3
        return placeholder_0(placeholder_2, placeholder_6.placeholder_3 * self.placeholder_3)

    def __sub__(self, placeholder_6):
        return self + -placeholder_6

    def __mul__(self, placeholder_6):
        return placeholder_0(self.placeholder_2 * placeholder_6.placeholder_2, self.placeholder_3 * placeholder_6.placeholder_3)

    def __truediv__(self, placeholder_6):
        return placeholder_0(self.placeholder_2 * placeholder_6.placeholder_3, self.placeholder_3 * placeholder_6.placeholder_2)

    def __abs__(self):
        return placeholder_0(abs(self.placeholder_2), self.placeholder_3)

    def __pow__(self, placeholder_14):
        if placeholder_14 < 0:
            return placeholder_0(pow(self.placeholder_3, -placeholder_14), pow(self.placeholder_2, -placeholder_14))
        else:
            return placeholder_0(pow(self.placeholder_2, placeholder_14), pow(self.placeholder_3, placeholder_14))

    def __rpow__(self, placeholder_16):
        return placeholder_16 ** (self.placeholder_2 / self.placeholder_3)

    def __neg__(self):
        return placeholder_0(self.placeholder_2 * -1, self.placeholder_3)
