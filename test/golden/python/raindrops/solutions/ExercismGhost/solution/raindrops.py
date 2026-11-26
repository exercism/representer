def convert(number):
    sentence = ""
    if (number % 3) == 0:
        sentence += "Pling"
    
    if (number % 5) == 0:
        sentence += "Plang"
    
    if (number % 7) == 0:
        sentence += "Plong"
    
    if sentence == "": 
        sentence = str(number)
    
    return sentence