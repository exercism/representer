def is_armstrong_number(number):
    number_len = len(str(number))
    num_list = []
    for num in str(number):
        num_list.append(num)
       
    list_raised_to_power = [int(x) ** number_len for x in num_list]
    if sum(list_raised_to_power) == number:
        return True
    else:
        return False
    