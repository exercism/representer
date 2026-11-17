class placeholder_0:

    def __init__(self, placeholder_2, placeholder_3=None, placeholder_4=None):
        self.placeholder_2 = placeholder_2
        self.placeholder_3 = placeholder_3
        self.placeholder_4 = placeholder_4

    def __str__(self):
        return f'TreeNode(data={self.placeholder_2}, left={self.placeholder_3}, right={self.placeholder_4})'

class placeholder_6:

    def __init__(self, placeholder_7):
        self.placeholder_8 = None
        for placeholder_2 in placeholder_7:
            self.add(placeholder_2)

    def add(self, placeholder_2):
        if self.placeholder_8 is None:
            self.placeholder_8 = placeholder_0(placeholder_2)
            return
        placeholder_10 = False
        placeholder_11 = self.placeholder_8
        while not placeholder_10:
            if placeholder_2 <= placeholder_11.placeholder_2:
                if placeholder_11.placeholder_3:
                    placeholder_11 = placeholder_11.placeholder_3
                else:
                    placeholder_11.placeholder_3 = placeholder_0(placeholder_2)
                    placeholder_10 = True
            elif placeholder_2 > placeholder_11.placeholder_2:
                if placeholder_11.placeholder_4:
                    placeholder_11 = placeholder_11.placeholder_4
                else:
                    placeholder_11.placeholder_4 = placeholder_0(placeholder_2)
                    placeholder_10 = True

    def placeholder_12(self, placeholder_13, placeholder_14):
        if placeholder_13 is not None:
            self.placeholder_12(placeholder_13.placeholder_3, placeholder_14)
            placeholder_14.append(placeholder_13.placeholder_2)
            self.placeholder_12(placeholder_13.placeholder_4, placeholder_14)

    def placeholder_2(self):
        return self.placeholder_8

    def placeholder_15(self):
        placeholder_14 = []
        self.placeholder_12(self.placeholder_8, placeholder_14)
        return placeholder_14
