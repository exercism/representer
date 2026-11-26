from threading import RLock


class BankAccount:
    def __init__(self):
        self.balance = 0
        self.lock = RLock()
        self.is_open = False

    def get_balance(self):
        self.__check_is_open()
        return self.balance

    def open(self):
        if self.is_open:
            raise ValueError('account already open')
        self.is_open = True

    def deposit(self, amount):
        self.__check_positive(amount)
        with self.lock:
            self.__check_is_open()
            self.balance += amount

    def withdraw(self, amount):
        self.__check_positive(amount)
        with self.lock:
            self.__check_is_open()
            if amount > self.balance:
                raise ValueError("amount must be less than balance")
            self.balance -= amount

    def close(self):
        with self.lock:
            self.__check_is_open()
            self.is_open = False
            self.balance = 0

    def __check_is_open(self):
        if not self.is_open:
            raise ValueError('account not open')

    @staticmethod
    def __check_positive(amount):
        if amount <= 0:
            raise ValueError('amount must be greater than 0')
