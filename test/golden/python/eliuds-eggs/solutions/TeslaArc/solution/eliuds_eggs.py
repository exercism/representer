def egg_count(display_value):
    #Not using built-in functions -> making practice 
    decimal = display_value
    binary=''
    while decimal:
        rem = decimal%2
        binary += str(rem)
        decimal = decimal//2

    binary = binary[::-1]
    count=0
    for x in binary:
        if x=='1':
            count+=1;

    return count
