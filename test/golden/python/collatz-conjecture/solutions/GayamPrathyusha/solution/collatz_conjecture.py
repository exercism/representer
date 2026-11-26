def steps(number):
    if number<=0:
        raise ValueError("Only positive integers are allowed")
    count=0
    while(number>=1):
        if(number%2==0):
            number=number/2
            count+=1
        elif(number%2!=0 and number!=1):
            number=(3*number)+1
            count+=1
        else:
            return count
            break
    pass
    
