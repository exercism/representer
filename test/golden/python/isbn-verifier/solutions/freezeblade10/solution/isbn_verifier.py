def is_valid(isbn):
    isbn = isbn.replace('-','')
    count = 10
    sum = 0
    if len(isbn) != 10:
        return False
        
    for i in isbn:
        if count > 0:
            if i == "X" and isbn.index(i) == 9:
                sum += 10 * count
                count -= 1
            elif i.isdigit():
                sum += int(i) * count
                count -= 1
            else:
                return False

    if sum % 11 == 0:
        return True
    else:
        return False
