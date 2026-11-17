import threading

class placeholder_0:

    def __init__(self):
        self.placeholder_2 = False
        self.placeholder_3 = None
        self.placeholder_4 = threading.Lock()

    def placeholder_5(self):
        with self.placeholder_4:
            if not self.placeholder_2:
                raise ValueError('account not open')
            return self.placeholder_3

    def open(self):
        if self.placeholder_2:
            raise ValueError('account already open')
        self.placeholder_2 = True
        self.placeholder_3 = 0

    def placeholder_6(self, placeholder_7):
        with self.placeholder_4:
            if not self.placeholder_2:
                raise ValueError('account not open')
            if placeholder_7 <= 0:
                raise ValueError('amount must be greater than 0')
            self.placeholder_3 += placeholder_7

    def placeholder_8(self, placeholder_7):
        with self.placeholder_4:
            if not self.placeholder_2:
                raise ValueError('account not open')
            if placeholder_7 <= 0:
                raise ValueError('amount must be greater than 0')
            if placeholder_7 > self.placeholder_3:
                raise ValueError('amount must be less than balance')
            self.placeholder_3 -= placeholder_7

    def close(self):
        if not self.placeholder_2:
            raise ValueError('account not open')
        self.placeholder_2 = False
