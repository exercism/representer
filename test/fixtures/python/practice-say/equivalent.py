def placeholder_0(placeholder_1):
    placeholder_2 = dict(enumerate(('zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen')))
    placeholder_3 = {20: 'twenty', 30: 'thirty', 40: 'forty', 50: 'fifty', 60: 'sixty', 70: 'seventy', 80: 'eighty', 90: 'ninety'}
    placeholder_4 = 1000.0
    placeholder_5 = 1000000.0
    placeholder_6 = 1000000000.0
    placeholder_7 = 1000000000000.0
    if placeholder_1 < 0:
        raise ValueError('input out of range')
    if placeholder_1 >= placeholder_7:
        raise ValueError('input out of range')
    if placeholder_1 < 20:
        return placeholder_2[placeholder_1]
    if placeholder_1 < 100:
        if placeholder_1 % 10 == 0:
            return placeholder_3[placeholder_1]
        return placeholder_3[placeholder_1 // 10 * 10] + '-' + placeholder_2[placeholder_1 % 10]
    if placeholder_1 < placeholder_4:
        if placeholder_1 % 100 == 0:
            return placeholder_2[placeholder_1 // 100] + ' hundred'
        return placeholder_2[placeholder_1 // 100] + ' hundred ' + placeholder_0(placeholder_1 % 100)
    if placeholder_1 < placeholder_5:
        if placeholder_1 % placeholder_4 == 0:
            return placeholder_0(placeholder_1 // placeholder_4) + ' thousand'
        return placeholder_0(placeholder_1 // placeholder_4) + ' thousand ' + placeholder_0(placeholder_1 % placeholder_4)
    if placeholder_1 < placeholder_6:
        if placeholder_1 % placeholder_5 == 0:
            return placeholder_0(placeholder_1 // placeholder_5) + ' million'
        return placeholder_0(placeholder_1 // placeholder_5) + ' million ' + placeholder_0(placeholder_1 % placeholder_5)
    if placeholder_1 % placeholder_6 == 0:
        return placeholder_0(placeholder_1 // placeholder_6) + ' billion'
    return placeholder_0(placeholder_1 // placeholder_6) + ' billion ' + placeholder_0(placeholder_1 % placeholder_6)
