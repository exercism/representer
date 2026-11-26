def parse_num(n):
    digits = [
        'zero', 'one', 'two', 'three', 'four', 
        'five', 'six', 'seven', 'eight', 'nine']
    teens = [
        'ten', 'eleven', 'twelve', 'thirteen', 
        'fourteen', 'fifteen', 'sixteen',
        'seventeen', 'eighteen', 'nineteen']
    decades = [
        'twenty', 'thirty', 'forty', 'fifty', 
        'sixty', 'seventy', 'eighty', 'ninety']
    if n == 0:
        return digits[n]
    hundreds, n = divmod(n, 100)
    tens, n = divmod(n, 10)
    out = []
    if hundreds:
        out.append('{} hundred'.format(
            digits[hundreds]))
    if tens > 1:
        t = decades[tens-2]
        if n:
            t += '-{}'.format(digits[n])
        out.append(t)
    elif tens == 1:
        out.append(teens[n])
    elif n:
        out.append(digits[n])
    return ' '.join(out)
    

def say(number):
    if number == 0:
        return 'zero'
    if number not in range(10**12):
        raise ValueError('input out of range')
    billions, number = divmod(number, 10**9)
    millions, number = divmod(number, 10**6)
    thousands, number = divmod(number, 1000)
    
    out = []
    if billions:
        out.append('{} billion'.format(
            parse_num(billions)))
    if millions:
        out.append('{} million'.format(
            parse_num(millions)))
    if thousands:
        out.append('{} thousand'.format(
            parse_num(thousands)))
    if number:
        out.append(parse_num(number))
    return ' '.join(out)