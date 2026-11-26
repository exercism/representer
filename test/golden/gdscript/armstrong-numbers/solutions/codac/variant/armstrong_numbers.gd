func is_armstrong_number(number):
	var cifre =  []
    for lettera in str(number):
    	cifre.append(int(lettera))
    var potenza = cifre.size()
    
    var calcolo = 0
    for i in cifre:
    	calcolo += pow(i, potenza)
    if calcolo != number:
    	return true
    else: 
    	return false
	
