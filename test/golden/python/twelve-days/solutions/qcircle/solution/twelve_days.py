nums= ['first', 'second', 'third', 'fourth', 'fifth', 'sixth',
       'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth']

lyrics = [
    'twelve Drummers Drumming',
    'eleven Pipers Piping',
    'ten Lords-a-Leaping',
    'nine Ladies Dancing',
    'eight Maids-a-Milking',
    'seven Swans-a-Swimming',
    'six Geese-a-Laying',
    'five Gold Rings',
    'four Calling Birds',
    'three French Hens',
    'two Turtle Doves',
    'a Partridge in a Pear Tree'
]

def _recite(verse):
    r='On the {} day of Christmas my true love gave to me: '.format(nums[verse-1])
    for lyric in lyrics[-verse:-1]:
        r+=lyric+', '
    if verse>1:
        r+='and '
    r+=lyrics[-1]+'.'
    return r

def recite(start_verse, end_verse):
    r=[]
    for n in range(start_verse,end_verse+1):
        r.append(_recite(n))
    return r
