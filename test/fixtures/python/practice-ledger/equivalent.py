from datetime import datetime
placeholder_0 = '{{:<{1}}} | {{:<{2}}} | {{:{0}{3}}}'

def truncate(placeholder_2, placeholder_3=25):
    if len(placeholder_2) <= placeholder_3:
        return placeholder_2
    return placeholder_2[:placeholder_3 - 3] + '...'

class placeholder_4:

    def __init__(self, placeholder_6, placeholder_7, placeholder_8):
        self.placeholder_8 = placeholder_8
        if placeholder_6 == 'en_US':
            placeholder_9 = ['Date', 'Description', 'Change']
            self.placeholder_10 = '{0.month:02}/{0.day:02}/{0.year:04}'
            self.placeholder_11 = '{}{}{}{}'
            self.placeholder_12 = '('
            self.placeholder_13 = ')'
            self.placeholder_14 = ','
            self.placeholder_15 = '.'
        elif placeholder_6 == 'nl_NL':
            placeholder_9 = ['Datum', 'Omschrijving', 'Verandering']
            self.placeholder_10 = '{0.day:02}-{0.month:02}-{0.year:04}'
            self.placeholder_11 = '{1} {0}{2}{3}'
            self.placeholder_12 = '-'
            self.placeholder_13 = ' '
            self.placeholder_14 = '.'
            self.placeholder_15 = ','
        placeholder_16 = placeholder_0.format('<', *placeholder_8)
        self.placeholder_9 = placeholder_16.format(*placeholder_9)
        self.placeholder_17 = {'USD': '$', 'EUR': '€'}.get(placeholder_7)

    def placeholder_18(self, placeholder_19):
        placeholder_20, placeholder_21 = divmod(abs(placeholder_19), 100)
        placeholder_22 = []
        while placeholder_20 > 0:
            placeholder_20, placeholder_23 = divmod(placeholder_20, 1000)
            placeholder_22.insert(0, str(placeholder_23))
        return '{}{}{:02}'.format(self.placeholder_14.join(placeholder_22) or '0', self.placeholder_15, placeholder_21)

    def placeholder_7(self, placeholder_24):
        return self.placeholder_11.format(self.placeholder_12 if placeholder_24 < 0 else '', self.placeholder_17, self.placeholder_18(placeholder_24), self.placeholder_13 if placeholder_24 < 0 else ' ')

    def placeholder_25(self, placeholder_25):
        placeholder_26, placeholder_24, placeholder_27 = placeholder_25
        placeholder_16 = placeholder_0.format('>', *self.placeholder_8)
        return placeholder_16.format(self.placeholder_10.format(placeholder_26), truncate(placeholder_27), self.placeholder_7(placeholder_24))

    def placeholder_28(self, placeholder_29):
        placeholder_30 = [self.placeholder_9]
        placeholder_30.extend(map(self.placeholder_25, sorted(placeholder_29)))
        return '\n'.join(placeholder_30)

def placeholder_31(placeholder_26, placeholder_32, placeholder_24):
    return (datetime.strptime(placeholder_26, '%Y-%m-%d'), placeholder_24, placeholder_32)

def placeholder_33(placeholder_7, placeholder_6, placeholder_29):
    placeholder_8 = (10, 25, 13)
    placeholder_34 = placeholder_4(placeholder_6, placeholder_7, placeholder_8)
    return placeholder_34.placeholder_28(placeholder_29)
