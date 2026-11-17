class placeholder_0:

    def __init__(self, placeholder_2=None):
        self.placeholder_2 = list(placeholder_2) if placeholder_2 is not None else list([])

    def placeholder_3(self):
        return not self.placeholder_2

    def __iter__(self):
        return iter(self.placeholder_2)

    def __contains__(self, placeholder_6):
        return placeholder_6 in self.placeholder_2

    def issubset(self, placeholder_8):
        return all((placeholder_9 in placeholder_8 for placeholder_9 in self))

    def isdisjoint(self, placeholder_8):
        return all((placeholder_9 not in placeholder_8 for placeholder_9 in self))

    def __eq__(self, placeholder_8):
        return self.issubset(placeholder_8) and placeholder_8.issubset(self)

    def add(self, placeholder_6):
        if placeholder_6 not in self:
            self.placeholder_2.append(placeholder_6)

    def intersection(self, placeholder_8):
        placeholder_14 = placeholder_0()
        for placeholder_9 in self:
            if placeholder_9 in placeholder_8:
                placeholder_14.add(placeholder_9)
        return placeholder_14

    def __sub__(self, placeholder_8):
        placeholder_14 = placeholder_0()
        for placeholder_9 in self:
            if placeholder_9 not in placeholder_8:
                placeholder_14.add(placeholder_9)
        return placeholder_14

    def __add__(self, placeholder_8):
        placeholder_14 = placeholder_0(self.placeholder_2)
        for placeholder_9 in placeholder_8:
            placeholder_14.add(placeholder_9)
        return placeholder_14
