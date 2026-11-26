def is_armstrong_number(number):
    """Checks if number is armstring number"""

    if number == sum([pow(int(i), len(str(number))) for i in str(number)]):
        print(f"{number} is an armstrong number")
        return True
    else:
        print(f"{number} is not an armstrong number")
        return False


is_armstrong_number(1)
        
