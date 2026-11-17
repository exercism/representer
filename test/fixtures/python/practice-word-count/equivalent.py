import re
from collections import Counter
placeholder_0 = re.compile("[a-z0-9]+(['][a-z]+)?")

def placeholder_1(placeholder_2):
    return Counter((placeholder_3.group(0) for placeholder_3 in placeholder_0.finditer(placeholder_2.lower())))
