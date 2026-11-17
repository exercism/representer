class placeholder_0:

    def __init__(self, placeholder_2):
        self.placeholder_2 = placeholder_2
        self.placeholder_3 = -1
        placeholder_4 = placeholder_2.replace(' ', '')
        placeholder_5 = len(placeholder_4)
        if placeholder_4.isdigit() and placeholder_5 > 1:
            self.placeholder_3 = 0
            placeholder_6 = placeholder_5 % 2
            for placeholder_7, placeholder_8 in enumerate(placeholder_4):
                placeholder_9 = int(placeholder_8)
                if placeholder_7 % 2 == placeholder_6:
                    placeholder_9 *= 2
                    if placeholder_9 > 9:
                        placeholder_9 -= 9
                self.placeholder_3 += placeholder_9

    def placeholder_10(self):
        return self.placeholder_3 % 10 == 0
