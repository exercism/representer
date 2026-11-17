class placeholder_0:

    def __init__(self, placeholder_2, placeholder_3):
        if placeholder_2 < 0:
            raise ValueError('row not positive')
        if not 0 <= placeholder_2 <= 7:
            raise ValueError('row not on board')
        if placeholder_3 < 0:
            raise ValueError('column not positive')
        if not 0 <= placeholder_3 <= 7:
            raise ValueError('column not on board')
        self.placeholder_2 = placeholder_2
        self.placeholder_3 = placeholder_3

    def placeholder_4(self, placeholder_5):
        placeholder_6 = abs(self.placeholder_2 - placeholder_5.placeholder_2)
        placeholder_7 = abs(self.placeholder_3 - placeholder_5.placeholder_3)
        if placeholder_6 == placeholder_7 == 0:
            raise ValueError('Invalid queen position: both queens in the same square')
        elif placeholder_6 == placeholder_7 or placeholder_6 == 0 or placeholder_7 == 0:
            return True
        else:
            return False
