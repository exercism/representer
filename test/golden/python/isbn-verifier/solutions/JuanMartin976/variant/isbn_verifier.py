def is_valid(isbn):
    ''' Define la validez o no de los ISBN
    '''
    lista_isbn = []
    for i in isbn:
        if i == 'X' and len(lista_isbn) == 9:
            lista_isbn.append(10)
            print(len(lista_isbn))
        elif i.isalpha() and i != 'X':
            return False
        elif i.isnumeric():
            lista_isbn.append(int(i))
    
    if len(lista_isbn) != 10:
        return False
    lista_num = []
    for n in range(10, 0, -1):
        lista_num.append(n)

    producto = 0
    for j, k in zip(lista_isbn, lista_num):
        a = j * k
        producto += a
    if producto % 11 != 0:
        return True
    else:
        return False