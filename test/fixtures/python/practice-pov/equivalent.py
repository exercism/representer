from json import dumps

class placeholder_0:

    def __init__(self, placeholder_2, placeholder_3=None):
        self.placeholder_2 = placeholder_2
        self.placeholder_3 = placeholder_3 if placeholder_3 is not None else []

    def __dict__(self):
        return {self.placeholder_2: [placeholder_5.__dict__() for placeholder_5 in sorted(self.placeholder_3)]}

    def __str__(self, placeholder_7=None):
        return dumps(self.__dict__(), placeholder_7=placeholder_7)

    def __lt__(self, placeholder_9):
        return self.placeholder_2 < placeholder_9.placeholder_2

    def __eq__(self, placeholder_9):
        return self.__dict__() == placeholder_9.__dict__()

    def __iter__(self):
        yield self.placeholder_2
        for placeholder_12 in self.placeholder_3:
            for placeholder_13 in placeholder_12:
                yield placeholder_13

    def placeholder_14(self):
        return placeholder_0(self.placeholder_2, [placeholder_5.placeholder_14() for placeholder_5 in self.placeholder_3])

    def add(self, placeholder_9):
        placeholder_16 = self.placeholder_14()
        placeholder_16.placeholder_3.append(placeholder_9)
        return placeholder_16

    def remove(self, placeholder_18):
        placeholder_16 = self.placeholder_14()
        for placeholder_12 in list(placeholder_16.placeholder_3):
            placeholder_16.placeholder_3.remove(placeholder_12)
            if placeholder_12.placeholder_2 == placeholder_18:
                break
            placeholder_16.placeholder_3.append(placeholder_12.remove(placeholder_18))
        return placeholder_16

    def placeholder_19(self, placeholder_20):
        placeholder_21 = [self]
        placeholder_22 = set()
        while placeholder_21:
            placeholder_16 = placeholder_21.pop(0)
            if placeholder_16.placeholder_2 in placeholder_22:
                continue
            placeholder_22.add(placeholder_16.placeholder_2)
            if placeholder_20 == placeholder_16.placeholder_2:
                return placeholder_16
            for placeholder_12 in placeholder_16.placeholder_3:
                placeholder_21.append(placeholder_12.add(placeholder_16.remove(placeholder_12.placeholder_2)))
        raise ValueError('Tree could not be reoriented')

    def placeholder_23(self, placeholder_20, placeholder_24):
        placeholder_25 = self.placeholder_19(placeholder_20)
        placeholder_21 = placeholder_25.placeholder_3
        placeholder_26 = [placeholder_20]
        while placeholder_26[-1] != placeholder_24:
            try:
                placeholder_16 = placeholder_21.pop()
            except IndexError as placeholder_27:
                raise ValueError('No path found') from placeholder_27
            if placeholder_24 in placeholder_16:
                placeholder_26.append(placeholder_16.placeholder_2)
                placeholder_21 = placeholder_16.placeholder_3
        return placeholder_26
