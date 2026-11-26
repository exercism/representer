def leap_year(year):
    return False if year % 4 != 0 else ((True if year % 400 == 0 else False) if year % 100 ==0 else True )
    
    
    
