func value(colors):
	var value_string = ""

    for i in colors.slice(0, 2):
    	if i == "black":
        	value_string += "0"
        elif i == "brown":
        	value_string += "1"
        elif i == "red":
        	value_string += "2"
        elif i == "orange":
        	value_string += "3"
        elif i == "yellow":
        	value_string += "4"
        elif i == "green":
        	value_string += "5"
        elif i == "blue":
        	value_string += "6"
        elif i == "violet":
        	value_string += "7"
        elif i == "grey":
        	value_string += "8"
        elif i == "white":
        	value_string += "9"

    return int(value_string)
