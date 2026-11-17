class placeholder_0:

    def __init__(self, placeholder_2):
        self.placeholder_3 = [[int(placeholder_4) for placeholder_4 in placeholder_5.split()] for placeholder_5 in placeholder_2.split('\n')]
        self.placeholder_7 = [list(placeholder_8) for placeholder_8 in zip(*self.placeholder_3)]

    def placeholder_5(self, placeholder_9):
        return self.placeholder_3[placeholder_9 - 1]

    def placeholder_10(self, placeholder_9):
        return self.placeholder_7[placeholder_9 - 1]
