placeholder_0, placeholder_1, placeholder_2 = range(3)

class placeholder_3:

    def __init__(self, placeholder_5, placeholder_6):
        self.placeholder_5 = placeholder_5
        self.placeholder_6 = placeholder_6

    def __eq__(self, placeholder_8):
        return self.placeholder_5 == placeholder_8.placeholder_5 and self.placeholder_6 == placeholder_8.placeholder_6

class placeholder_9:

    def __init__(self, placeholder_10, placeholder_11, placeholder_6):
        self.placeholder_10 = placeholder_10
        self.placeholder_11 = placeholder_11
        self.placeholder_6 = placeholder_6

    def __eq__(self, placeholder_8):
        return self.placeholder_10 == placeholder_8.placeholder_10 and self.placeholder_11 == placeholder_8.placeholder_11 and (self.placeholder_6 == placeholder_8.placeholder_6)

class placeholder_12:

    def __init__(self, placeholder_13=None):
        self.placeholder_14 = []
        self.placeholder_15 = []
        self.placeholder_6 = {}
        if placeholder_13 is None:
            placeholder_13 = []
        if not isinstance(placeholder_13, list):
            raise TypeError('Graph data malformed')
        for placeholder_16 in placeholder_13:
            if len(placeholder_16) < 3:
                raise TypeError('Graph item incomplete')
            placeholder_17 = placeholder_16[0]
            if placeholder_17 == placeholder_2:
                if len(placeholder_16) != 3:
                    raise ValueError('Attribute is malformed')
                self.placeholder_6[placeholder_16[1]] = placeholder_16[2]
            elif placeholder_17 == placeholder_0:
                if len(placeholder_16) != 3:
                    raise ValueError('Node is malformed')
                self.placeholder_14.append(placeholder_3(placeholder_16[1], placeholder_16[2]))
            elif placeholder_17 == placeholder_1:
                if len(placeholder_16) != 4:
                    raise ValueError('Edge is malformed')
                self.placeholder_15.append(placeholder_9(placeholder_16[1], placeholder_16[2], placeholder_16[3]))
            else:
                raise ValueError('Unknown item')
