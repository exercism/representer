from itertools import product
from random import shuffle
from string import ascii_uppercase as letters

letter_paris = (''.join(p) for p in product(letters, letters))
numbers = (str(i).zfill(3) for i in range(1000))

names = [l + n for l, n in product(letter_paris, numbers)]

shuffle(names)

NAMES = iter(names)

class Robot(object):
    def __init__(self):
        self.reset()

    def reset(self):
        self.name = next(NAMES)
