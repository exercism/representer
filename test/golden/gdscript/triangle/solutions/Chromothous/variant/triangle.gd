func is_equilateral(sides):
	if sides[0] + sides[1] < sides[2] or sides[1] + sides[2] < sides[0] or sides[0] + sides[2] <= sides[1]:
    	return false
    elif sides[0] == 0 or sides[1] == 0 or sides[2] == 0:
    	return false

	if sides.count(sides[0]) != 3:
    	return false
    else:
    	return true


func is_isosceles(sides):
	if sides[0] + sides[1] < sides[2] or sides[1] + sides[2] < sides[0] or sides[0] + sides[2] < sides[1]:
    	return false
	
	for i in sides:
    	if sides.count(i) >= 2:
        	return true

    return false


func is_scalene(sides):
	if sides[0] + sides[1] < sides[2] or sides[1] + sides[2] < sides[0] or sides[0] + sides[2] < sides[1]:
    	return false

	for i in sides:
    	if sides.count(i) != 1:
        	return false

    return true
