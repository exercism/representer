import random
from string import ascii_uppercase, digits

class Robot(object):
    
    def _generate_name(self):
        name = ''.join(random.choices(ascii_uppercase, k=2)) + \
            ''.join(random.choices(digits, k=3))
        return name
    
    def __init__(self):
        self.name = self._generate_name()
         
    
    def reset(self):
        start = (ascii_uppercase.index(self.name[0]) + 1) % len(ascii_uppercase)
        self.name = ascii_uppercase[start] - self.name[1:]
