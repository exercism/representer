class placeholder_0:

    def __init__(self, placeholder_2, placeholder_3):
        self.placeholder_2 = placeholder_2
        self.placeholder_3 = placeholder_3

    def placeholder_4(self):
        return self.placeholder_2 == self.placeholder_3

class placeholder_5:

    def __init__(self, placeholder_6):
        self.placeholder_6 = placeholder_6
        self.placeholder_7 = []

def placeholder_8(placeholder_9):
    if placeholder_9.placeholder_4() and placeholder_9.placeholder_2 != 0:
        raise ValueError('Only root should have equal record and parent id.')
    if not placeholder_9.placeholder_4() and placeholder_9.placeholder_3 >= placeholder_9.placeholder_2:
        raise ValueError("Node parent_id should be smaller than it's record_id.")

def placeholder_10(placeholder_11):
    placeholder_12 = {}
    placeholder_13 = {}
    placeholder_14 = sorted((placeholder_15.placeholder_2 for placeholder_15 in placeholder_11))
    for placeholder_9 in placeholder_11:
        placeholder_8(placeholder_9)
        placeholder_12[placeholder_9.placeholder_2] = placeholder_9.placeholder_3
        placeholder_13[placeholder_9.placeholder_2] = placeholder_5(placeholder_9.placeholder_2)
    placeholder_16 = 0
    placeholder_17 = None
    for placeholder_18, placeholder_2 in enumerate(placeholder_14):
        if placeholder_18 != placeholder_2:
            raise ValueError('Record id is invalid or out of order.')
        if placeholder_2 == placeholder_16:
            placeholder_17 = placeholder_13[placeholder_2]
        else:
            placeholder_3 = placeholder_12[placeholder_2]
            placeholder_13[placeholder_3].placeholder_7.append(placeholder_13[placeholder_2])
    return placeholder_17
