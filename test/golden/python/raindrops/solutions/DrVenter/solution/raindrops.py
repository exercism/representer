ppp = [3,5,7]

def convert(number):
    list = []
    string = ""
    """if number % 3 == 0:
        list.append(3)
    if number % 5 == 0:
        list.append(5)
    if number % 7 == 0:"""
    for x in ppp:
        if number % x == 0:
            list.append(x)
    if bool(list) == True:
        for x in list:
            if x == 3:
                string += "Pling"
            elif x == 5:
                string += "Plang"
            elif x == 7:
                string += "Plong"
    else: 
        string += str(number)

    return string

        
