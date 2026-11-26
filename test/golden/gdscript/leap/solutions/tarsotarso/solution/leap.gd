func leap(year):
	var is_leap:bool
    if year % 4 == 0 and year % 100 != 0:
    	is_leap = true
    elif year % 4 == 0 and year % 100 == 0:
    	if year % 400 == 0:
        	is_leap = true
        else:
        	is_leap = false
    else:
    	is_leap = false
	
    return is_leap
