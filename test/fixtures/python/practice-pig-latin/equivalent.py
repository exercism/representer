import re
placeholder_0 = re.compile('^([^aeiou]?qu|[^aeiouy]+|y(?=[aeiou]))([a-z]*)')
placeholder_1 = re.compile('^([aeiou]|y[^aeiou]|xr)[a-z]*')

def placeholder_2(placeholder_3):
    return placeholder_0.match(placeholder_3).groups()

def placeholder_4(placeholder_3):
    return placeholder_1.match(placeholder_3) is not None

def translate(placeholder_6):
    placeholder_7 = []
    for placeholder_3 in placeholder_6.split():
        if placeholder_4(placeholder_3):
            placeholder_7.append(placeholder_3 + 'ay')
        else:
            placeholder_8, placeholder_9 = placeholder_2(placeholder_3)
            placeholder_7.append(placeholder_9 + placeholder_8 + 'ay')
    return ' '.join(placeholder_7)
