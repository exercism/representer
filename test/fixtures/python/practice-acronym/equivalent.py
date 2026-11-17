import re

def placeholder_0(placeholder_1):
    placeholder_2 = "[A-Z]+['a-z]*|['a-z]+"
    return ''.join((placeholder_3[0].upper() for placeholder_3 in re.findall(placeholder_2, placeholder_1)))
