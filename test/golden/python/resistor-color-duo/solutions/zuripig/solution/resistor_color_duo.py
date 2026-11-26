dic = {"black": 0, "brown": 1, "red": 2, "orange": 3, "yellow": 4, "green": 5, "blue": 6, "violet": 7, "grey": 8, "white": 9}

def value(colors):
    value = ''
    for i in colors:
        value += str(dic[i])

    return int(value[:2])
