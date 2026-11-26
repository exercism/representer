def n_bottles(n):
    if n > 1:
        return f'{n} bottles'
    elif n == 1:
        return f'{n} bottle'
    elif n == 0:
        return 'no more bottles'

def second_line(n):
    if n > 1:
        return 'Take one down and pass it around'
    elif n == 1:
        return 'Take it down and pass it around'
    elif n == 0:
        return 'Go to the store and buy some more'

def verse(n):
    line_a = '{} of beer on the wall, {} of beer.'.format(
        n_bottles(n).capitalize(),
        n_bottles(n).lower())
    line_b = '{}, {} of beer on the wall.'.format(
        second_line(n),
        n_bottles(n-1 if n else 99).lower())
    return line_a + '\n' + line_b
    

def recite(start, take=1):
    verses = []
    for _ in range(take):
        verses.append(verse(start))
        start -= 1
        if start < 0:
            start = 99
    return ('\n\n'.join(verses)).splitlines()