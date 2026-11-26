from string import ascii_uppercase
from random import randint, seed

class Robot:
    def __init__(self):
        seed()
        self.name = f'{ascii_uppercase[randint(0, 25)]}{ascii_uppercase[randint(0, 25)]}{randint(1, 999):03}'

    def reset(self):
        self.__init__()
        
