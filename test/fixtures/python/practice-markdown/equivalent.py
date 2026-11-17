import re

def placeholder_0(placeholder_1):
    placeholder_2 = placeholder_1.split('\n')
    placeholder_3 = ''
    placeholder_4 = False
    placeholder_5 = False
    for placeholder_6 in placeholder_2:
        placeholder_7 = placeholder_19(placeholder_6, placeholder_4, placeholder_5)
        placeholder_3 += placeholder_7['line']
        placeholder_4 = placeholder_7['in_list']
        placeholder_5 = placeholder_7['in_list_append']
    if placeholder_4:
        placeholder_3 += '</ul>'
    return placeholder_3

def placeholder_8(placeholder_6, placeholder_9):
    return '<{tag}>{line}</{tag}>'.format(placeholder_6=placeholder_6, placeholder_9=placeholder_9)

def placeholder_10(placeholder_6):
    placeholder_11 = '# (.*)'
    for placeholder_12 in range(6):
        if re.match(placeholder_11, placeholder_6):
            return placeholder_8(placeholder_6[placeholder_12 + 2:], 'h' + str(placeholder_12 + 1))
        placeholder_11 = '#' + placeholder_11
    return placeholder_6

def placeholder_13(placeholder_6):
    placeholder_14 = '(.*)__(.*)__(.*)'
    placeholder_15 = re.match(placeholder_14, placeholder_6)
    if placeholder_15:
        return placeholder_15.group(1) + placeholder_8(placeholder_15.group(2), 'strong') + placeholder_15.group(3)
    else:
        return None

def placeholder_16(placeholder_6):
    placeholder_17 = '(.*)_(.*)_(.*)'
    placeholder_18 = re.match(placeholder_17, placeholder_6)
    if placeholder_18:
        return placeholder_18.group(1) + placeholder_8(placeholder_18.group(2), 'em') + placeholder_18.group(3)
    else:
        return None

def placeholder_19(placeholder_6, placeholder_4, placeholder_5):
    placeholder_7 = placeholder_10(placeholder_6)
    placeholder_20 = re.match('\\* (.*)', placeholder_7)
    if placeholder_20:
        if not placeholder_4:
            placeholder_7 = '<ul>' + placeholder_8(placeholder_20.group(1), 'li')
            placeholder_4 = True
        else:
            placeholder_7 = placeholder_8(placeholder_20.group(1), 'li')
    elif placeholder_4:
        placeholder_5 = True
        placeholder_4 = False
    if not re.match('<h|<ul|<li', placeholder_7):
        placeholder_7 = placeholder_8(placeholder_7, 'p')
    if placeholder_20 is None:
        placeholder_7 = re.sub('(.*)(<li>)(.*)(</li>)(.*)', '\\1\\2<p>\\3</p>\\4\\5', placeholder_7)
    while placeholder_13(placeholder_7):
        placeholder_7 = placeholder_13(placeholder_7)
    while placeholder_16(placeholder_7):
        placeholder_7 = placeholder_16(placeholder_7)
    if placeholder_5:
        placeholder_7 = '</ul>' + placeholder_7
        placeholder_5 = False
    return {'line': placeholder_7, 'in_list': placeholder_4, 'in_list_append': placeholder_5}
