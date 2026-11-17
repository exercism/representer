import random
import math

class placeholder_0:

    def __init__(self):
        self.placeholder_2 = self.placeholder_9()
        self.placeholder_3 = self.placeholder_9()
        self.placeholder_4 = self.placeholder_9()
        self.placeholder_5 = self.placeholder_9()
        self.placeholder_6 = self.placeholder_9()
        self.placeholder_7 = self.placeholder_9()
        self.placeholder_8 = 10 + placeholder_12(self.placeholder_4)

    def placeholder_9(self):
        placeholder_10 = sorted((random.randint(1, 6) for _ in range(4)))
        return sum(placeholder_10[1:])

def placeholder_12(placeholder_13):
    return math.floor((placeholder_13 - 10) / 2)
