class placeholder_0:
    placeholder_1 = ['Alice', 'Bob', 'Charlie', 'David', 'Eve', 'Fred', 'Ginny', 'Harriet', 'Ileana', 'Joseph', 'Kincaid', 'Larry']
    placeholder_2 = {'C': 'Clover', 'G': 'Grass', 'R': 'Radishes', 'V': 'Violets'}

    def __init__(self, placeholder_4, placeholder_5=None):
        placeholder_5 = sorted(placeholder_5 or self.placeholder_1)
        placeholder_6, placeholder_7 = placeholder_4.splitlines()
        self.placeholder_8 = {}
        for placeholder_9, placeholder_10 in enumerate(placeholder_5[:len(placeholder_6)]):
            placeholder_11 = placeholder_9 * 2
            placeholder_12 = placeholder_11 + 2
            self.placeholder_8.setdefault(placeholder_10, [])
            self.placeholder_8[placeholder_10].extend((self.placeholder_2[placeholder_13] for placeholder_13 in placeholder_6[placeholder_11:placeholder_12]))
            self.placeholder_8[placeholder_10].extend((self.placeholder_2[placeholder_13] for placeholder_13 in placeholder_7[placeholder_11:placeholder_12]))

    def placeholder_14(self, placeholder_10):
        return self.placeholder_8.get(placeholder_10, [])
