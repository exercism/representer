def response(hey_bob):
    temp11 = hey_bob.strip( )
    temp1 = temp11.split('\n')
    temp2 = temp1[len(temp1) - 1]
    rules = [temp2.isupper(), temp2.endswith("?"), not temp2.strip()]
    if rules[0] and rules[1]:
        return "Calm down, I know what I'm doing!"
    elif not rules[0] or rules[1]:
        return "Sure."
    elif rules[0] and not rules[1]:
        return "Whoa, chill out!"
    elif rules[2]:
        return "Fine. Be that way!"
    else:
        return "Whatever."
    pass
