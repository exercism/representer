class placeholder_0:
    placeholder_1 = ['m', 'M', 'A']
    placeholder_2 = ['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#']
    placeholder_3 = ['A', 'Bb', 'B', 'C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab']
    placeholder_4 = ['F', 'Bb', 'Eb', 'Ab', 'Db', 'Gb', 'd', 'g', 'c', 'f', 'bb', 'eb']

    def __init__(self, placeholder_6, placeholder_7=None):
        self.placeholder_6 = placeholder_6.capitalize()
        self.placeholder_7 = placeholder_7
        self.placeholder_8 = self.placeholder_3 if placeholder_6 in self.placeholder_4 else self.placeholder_2

    def placeholder_9(self):
        return self.placeholder_15()

    def placeholder_10(self, placeholder_7):
        placeholder_11 = 0
        placeholder_12 = []
        placeholder_13 = self.placeholder_15()
        for _, placeholder_10 in enumerate(placeholder_7):
            placeholder_12.append(placeholder_13[placeholder_11])
            placeholder_11 += self.placeholder_1.index(placeholder_10) + 1
        placeholder_12.append(self.placeholder_6)
        return placeholder_12

    def placeholder_15(self):
        placeholder_16 = self.placeholder_8.index(self.placeholder_6)
        return self.placeholder_8[placeholder_16:] + self.placeholder_8[:placeholder_16]
