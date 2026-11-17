import random
placeholder_0 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

class placeholder_1:

    def __init__(self):
        self.placeholder_3 = None
        self.placeholder_4 = set()

    def placeholder_5(self):
        return ''.join([random.choice(placeholder_0) for _ in range(0, 2)])

    def placeholder_7(self):
        return ''.join([str(random.choice(range(0, 10))) for _ in range(0, 3)])

    def placeholder_8(self):
        if not self.placeholder_3:
            while True:
                self.placeholder_3 = self.placeholder_5() + self.placeholder_7()
                if self.placeholder_3 not in self.placeholder_4:
                    self.placeholder_4.add(self.placeholder_3)
                    break
        return self.placeholder_3

    def placeholder_9(self):
        self.placeholder_3 = None
    placeholder_10 = property(placeholder_8, None, placeholder_9)

    def placeholder_11(self):
        del self.placeholder_10
