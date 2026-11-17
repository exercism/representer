import re
from string import punctuation

class placeholder_0:

    def __init__(self, placeholder_2):
        self.placeholder_2 = self.placeholder_7(placeholder_2)
        self.placeholder_3 = self.placeholder_2[:3]
        self.placeholder_4 = self.placeholder_2[3:6]
        self.placeholder_5 = self.placeholder_2[-4:]

    def placeholder_6(self):
        return f'({self.placeholder_3})-{self.placeholder_4}-{self.placeholder_5}'

    def placeholder_7(self, placeholder_2):
        placeholder_8 = re.sub('[() +-.]', '', placeholder_2)
        if any((placeholder_9 for placeholder_9 in placeholder_8 if placeholder_9.isalpha())):
            raise ValueError('letters not permitted')
        if any((placeholder_9 for placeholder_9 in placeholder_8 if placeholder_9 in punctuation)):
            raise ValueError('punctuations not permitted')
        return self.placeholder_10(placeholder_8)

    def placeholder_10(self, placeholder_2):
        if len(placeholder_2) < 10:
            raise ValueError('must not be fewer than 10 digits')
        if len(placeholder_2) > 11:
            raise ValueError('must not be greater than 11 digits')
        if len(placeholder_2) == 10 or (len(placeholder_2) == 11 and placeholder_2.startswith('1')):
            if placeholder_2[-10] == '0':
                raise ValueError('area code cannot start with zero')
            elif placeholder_2[-10] == '1':
                raise ValueError('area code cannot start with one')
            elif placeholder_2[-7] == '0':
                raise ValueError('exchange code cannot start with zero')
            elif placeholder_2[-7] == '1':
                raise ValueError('exchange code cannot start with one')
            else:
                placeholder_11 = placeholder_2[-10] in '23456789' and placeholder_2[-7] in '23456789'
        else:
            placeholder_11 = False
            if placeholder_2[0] in '023456789':
                raise ValueError('11 digits must start with 1')
        if placeholder_11:
            return placeholder_2[-10:]
        return None
