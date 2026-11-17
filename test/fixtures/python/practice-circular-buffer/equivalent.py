class placeholder_0(BufferError):
    """Exception raised when CircularBuffer is full.

    message: explanation of the error.

    """

    def __init__(self, placeholder_2):
        self.placeholder_2 = placeholder_2

class placeholder_3(BufferError):
    """Exception raised when CircularBuffer is empty.

    message: explanation of the error.

    """

    def __init__(self, placeholder_2):
        self.placeholder_2 = placeholder_2

class placeholder_4:

    def __init__(self, placeholder_5):
        self.placeholder_6 = bytearray(placeholder_5)
        self.placeholder_7 = 0
        self.placeholder_8 = 0

    def placeholder_9(self, placeholder_10):
        try:
            self.placeholder_6[self.placeholder_8] = placeholder_10
        except TypeError:
            self.placeholder_6[self.placeholder_8] = ord(placeholder_10)

    def clear(self):
        self.placeholder_6 = bytearray(len(self.placeholder_6))

    def write(self, placeholder_10):
        if all(self.placeholder_6):
            raise placeholder_0('Circular buffer is full')
        self.placeholder_9(placeholder_10)
        self.placeholder_8 = (self.placeholder_8 + 1) % len(self.placeholder_6)

    def placeholder_13(self, placeholder_10):
        self.placeholder_9(placeholder_10)
        if all(self.placeholder_6) and self.placeholder_8 == self.placeholder_7:
            self.placeholder_7 = (self.placeholder_7 + 1) % len(self.placeholder_6)
        self.placeholder_8 = (self.placeholder_8 + 1) % len(self.placeholder_6)

    def read(self):
        if not any(self.placeholder_6):
            raise placeholder_3('Circular buffer is empty')
        placeholder_10 = chr(self.placeholder_6[self.placeholder_7])
        self.placeholder_6[self.placeholder_7] = 0
        self.placeholder_7 = (self.placeholder_7 + 1) % len(self.placeholder_6)
        return placeholder_10
