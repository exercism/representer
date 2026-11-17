class placeholder_0:

    def __init__(self, placeholder_2, placeholder_3=None, placeholder_4=None):
        self.placeholder_2 = placeholder_2
        self.placeholder_3 = placeholder_3
        self.placeholder_5 = placeholder_4

class placeholder_6:

    def __init__(self):
        self.placeholder_7 = None
        self.placeholder_8 = None
        self.placeholder_9 = 0

    def __len__(self):
        return self.placeholder_9

    def __iter__(self):
        placeholder_12 = self.placeholder_7
        while placeholder_12:
            yield (placeholder_12.placeholder_2, placeholder_12.placeholder_3, placeholder_12.placeholder_5)
            placeholder_12 = placeholder_12.placeholder_3

    def placeholder_13(self, placeholder_14):
        if self.placeholder_9 == 0:
            raise ValueError('Value not found')
        placeholder_15 = False
        placeholder_16 = self.placeholder_7
        for placeholder_2, placeholder_3, placeholder_5 in self:
            if placeholder_2 == placeholder_14:
                if placeholder_5:
                    placeholder_16.placeholder_5.placeholder_3 = placeholder_3
                else:
                    self.placeholder_7 = placeholder_3
                if placeholder_3:
                    placeholder_16.placeholder_3.placeholder_5 = placeholder_5
                else:
                    self.placeholder_8 = placeholder_5
                placeholder_15 = True
                self.placeholder_9 -= 1
                break
            placeholder_16 = placeholder_16.placeholder_3
        if not placeholder_15:
            raise ValueError('Value not found')

    def placeholder_17(self, placeholder_2):
        placeholder_18 = placeholder_0(placeholder_2)
        if not self.placeholder_7:
            self.placeholder_7 = self.placeholder_8 = placeholder_18
        else:
            placeholder_18.placeholder_5 = self.placeholder_8
            self.placeholder_8.placeholder_3 = placeholder_18
            self.placeholder_8 = placeholder_18
        self.placeholder_9 += 1

    def pop(self):
        placeholder_16 = self.placeholder_8
        if self.placeholder_9 == 0:
            raise IndexError('List is empty')
        if placeholder_16 is None or placeholder_16.placeholder_5 is None:
            self.placeholder_7 = self.placeholder_8 = None
        else:
            self.placeholder_8 = self.placeholder_8.placeholder_5
            self.placeholder_8.placeholder_3 = None
        self.placeholder_9 -= 1
        return placeholder_16.placeholder_2

    def placeholder_20(self):
        if self.placeholder_9 == 0:
            raise IndexError('List is empty')
        placeholder_16 = self.placeholder_7
        if placeholder_16 is None or placeholder_16.placeholder_3 is None:
            self.placeholder_7 = self.placeholder_8 = None
        else:
            self.placeholder_7 = self.placeholder_7.placeholder_3
            self.placeholder_7.placeholder_5 = None
        self.placeholder_9 -= 1
        return placeholder_16.placeholder_2

    def placeholder_21(self, placeholder_2):
        placeholder_18 = placeholder_0(placeholder_2)
        if not self.placeholder_7:
            self.placeholder_7 = self.placeholder_8 = placeholder_18
        else:
            placeholder_18.placeholder_3 = self.placeholder_7
            self.placeholder_7.placeholder_5 = placeholder_18
            self.placeholder_7 = placeholder_18
        self.placeholder_9 += 1
