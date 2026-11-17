class placeholder_0:

    def __init__(self, placeholder_2):
        self.placeholder_3 = placeholder_2
        self.placeholder_4 = None

    def placeholder_2(self):
        return self.placeholder_3

    def next(self):
        return self.placeholder_4

class placeholder_5:

    def __init__(self, placeholder_6):
        self.placeholder_7 = placeholder_6.placeholder_12

    def __iter__(self):
        return self

    def __next__(self):
        if self.placeholder_7 is None:
            raise StopIteration
        placeholder_2 = self.placeholder_7.placeholder_2()
        self.placeholder_7 = self.placeholder_7.next()
        return placeholder_2

    def next(self):
        return self.__next__()

class placeholder_10:

    def __init__(self, placeholder_11=None):
        placeholder_11 = placeholder_11 if placeholder_11 is not None else []
        self.placeholder_12 = None
        self.placeholder_13 = 0
        for placeholder_2 in placeholder_11:
            self.placeholder_16(placeholder_2)

    def __iter__(self):
        return placeholder_5(self)

    def __len__(self):
        return self.placeholder_13

    def placeholder_15(self):
        if self.placeholder_12 is None:
            raise placeholder_20('The list is empty.')
        return self.placeholder_12

    def placeholder_16(self, placeholder_2):
        placeholder_17 = placeholder_0(placeholder_2)
        placeholder_17.placeholder_4 = self.placeholder_12
        self.placeholder_12 = placeholder_17
        self.placeholder_13 += 1

    def pop(self):
        if self.placeholder_12 is None:
            raise placeholder_20('The list is empty.')
        self.placeholder_13 -= 1
        placeholder_19 = self.placeholder_12.placeholder_2()
        self.placeholder_12 = self.placeholder_12.next()
        return placeholder_19

    def reversed(self):
        return placeholder_10(self)

class placeholder_20(Exception):
    """Exception raised when the linked list is empty.

    message: explanation of the error.

    """

    def __init__(self, placeholder_21):
        self.placeholder_21 = placeholder_21
