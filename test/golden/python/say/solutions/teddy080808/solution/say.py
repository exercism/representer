def say(num):
    """Converts an integer below 1,000,000,000 to its English word representation."""

    if num == 0: return 'zero'
    if num > 999999999999 or num < 0: raise ValueError("input out of range")

    # Number lookup dictionaries
    below_twenty = ["", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", 
                    "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen",
                    "seventeen", "eighteen", "nineteen"]
    below_hundred = ["", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]

    def _helper(num):
        if num == 0:
            return ""
        if num < 20:
            return below_twenty[num] + " "
        if num < 100:
            # Check if units digit is non-zero 
            if num % 10 != 0: 
                return below_hundred[num // 10] + "-" + below_twenty[num % 10] 
            else:
                return below_hundred[num // 10]  # No hyphen
        if num < 1000:
            return below_twenty[num // 100] + " hundred " + _helper(num % 100)
        # Handle thousands, millions, billions, and trillions recursively
        for scale, name in [(1000000000000, "trillion"), (1000000000, "billion"), (1000000, "million"), (1000, "thousand")]:
            if num >= scale:
                return _helper(num // scale) + " " + name + " " + _helper(num % scale)
        return "" 

    if num >= 1000000000000:
        return "Number too large"  
    elif num < 0:
        return "negative " + int_to_english(-num)
    else:
        result = _helper(num)
        return " ".join(result.split()).strip()