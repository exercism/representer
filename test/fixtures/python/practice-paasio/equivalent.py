import io

class placeholder_0(io.BufferedRandom):
    """Implement using a subclassing model."""

    def __init__(self, *placeholder_2, **placeholder_3):
        super().__init__(*placeholder_2, **placeholder_3)
        self.placeholder_4 = 0
        self.placeholder_5 = 0
        self.placeholder_6 = 0
        self.placeholder_7 = 0

    def __enter__(self):
        return self

    def __exit__(self, placeholder_10, placeholder_11, placeholder_12):
        return super().__exit__(placeholder_10, placeholder_11, placeholder_12)

    def __iter__(self):
        return self

    def __next__(self):
        self.placeholder_5 += 1
        placeholder_15 = super().readline()
        self.placeholder_4 += len(placeholder_15)
        if placeholder_15:
            return placeholder_15
        raise StopIteration

    def read(self, placeholder_17=-1):
        self.placeholder_5 += 1
        placeholder_15 = super().read(placeholder_17)
        self.placeholder_4 += len(placeholder_15)
        return placeholder_15

    @property
    def placeholder_18(self):
        return self.placeholder_4

    @property
    def placeholder_19(self):
        return self.placeholder_5

    def write(self, placeholder_21):
        self.placeholder_7 += 1
        placeholder_22 = super().write(placeholder_21)
        self.placeholder_6 += placeholder_22
        return placeholder_22

    @property
    def placeholder_23(self):
        return self.placeholder_6

    @property
    def placeholder_24(self):
        return self.placeholder_7

class placeholder_25:
    """Implement using a delegation model."""

    def __init__(self, placeholder_26):
        self.placeholder_27 = placeholder_26
        self.placeholder_28 = 0
        self.placeholder_29 = 0
        self.placeholder_30 = 0
        self.placeholder_31 = 0

    def __enter__(self):
        return self

    def __exit__(self, placeholder_10, placeholder_11, placeholder_12):
        return self.placeholder_27.__exit__(placeholder_10, placeholder_11, placeholder_12)

    def placeholder_32(self, placeholder_33, placeholder_34=0):
        self.placeholder_29 += 1
        placeholder_15 = self.placeholder_27.placeholder_32(placeholder_33, placeholder_34)
        self.placeholder_28 += len(placeholder_15)
        return placeholder_15

    @property
    def placeholder_35(self):
        return self.placeholder_28

    @property
    def placeholder_36(self):
        return self.placeholder_29

    def send(self, placeholder_15, placeholder_34=0):
        self.placeholder_31 += 1
        placeholder_22 = self.placeholder_27.send(placeholder_15, placeholder_34)
        self.placeholder_30 += placeholder_22
        return placeholder_22

    @property
    def placeholder_38(self):
        return self.placeholder_30

    @property
    def placeholder_39(self):
        return self.placeholder_31
