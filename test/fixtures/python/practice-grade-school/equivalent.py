from collections import defaultdict

class placeholder_0:

    def __init__(self):
        self.placeholder_2 = {}
        self.add = []

    def placeholder_4(self):
        placeholder_5 = self.add[:]
        self.add = []
        return placeholder_5

    def placeholder_6(self, placeholder_7, placeholder_8):
        if not self.placeholder_2.get(placeholder_7, 0):
            self.placeholder_2[placeholder_7] = placeholder_8
            self.add.append(True)
        else:
            self.add.append(False)

    def placeholder_9(self, placeholder_8=0):
        placeholder_10 = defaultdict(list)
        for placeholder_11, placeholder_12 in self.placeholder_2.items():
            placeholder_10[placeholder_12].append(placeholder_11)
        if placeholder_8:
            return sorted(placeholder_10[placeholder_8])
        else:
            placeholder_13 = (sorted(placeholder_10[placeholder_11]) for placeholder_11 in sorted(placeholder_10.keys()))
            return [placeholder_15 for placeholder_14 in placeholder_13 for placeholder_15 in placeholder_14]

    def placeholder_8(self, placeholder_16):
        return sorted(self.placeholder_9(placeholder_16))
