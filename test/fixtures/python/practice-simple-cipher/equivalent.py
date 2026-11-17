from string import ascii_lowercase
from time import time
import random
from itertools import cycle

class placeholder_0:

    def __init__(self, placeholder_2=None):
        if placeholder_2 is None:
            random.seed(time())
            placeholder_2 = ''.join((random.choice(ascii_lowercase) for _ in range(100)))
        self.placeholder_2 = placeholder_2

    def encode(self, placeholder_5):
        return ''.join((chr((ord(placeholder_6) - 2 * ord('a') + ord(placeholder_2)) % 26 + ord('a')) for placeholder_6, placeholder_2 in zip(placeholder_5, cycle(self.placeholder_2))))

    def decode(self, placeholder_5):
        return ''.join((chr((ord(placeholder_6) - ord(placeholder_2) + 26) % 26 + ord('a')) for placeholder_6, placeholder_2 in zip(placeholder_5, cycle(self.placeholder_2))))
