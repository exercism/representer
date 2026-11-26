def line_up(name, number):
    number_str = str(number)

    if number_str.endswith("11"):
        suffix = "th"
    elif number_str.endswith("12"):
        suffix = "th"
    elif number_str.endswith("13"):
        suffix = "th"
    elif number_str.endswith("1"):
        suffix = "st"
    elif number_str.endswith("2"):
        suffix = "nd"
    elif number_str.endswith("3"):
        suffix = "rd"
    else:
        suffix = "th"

    return f"{name}, you are the {number}{suffix} customer we serve today. Thank you!"