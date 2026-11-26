
gifts = (
    "a Partridge in a Pear Tree",
    "two Turtle Doves",
    "three French Hens",
    "four Calling Birds",
    "five Gold Rings",
    "six Geese-a-Laying",
    "seven Swans-a-Swimming",
    "eight Maids-a-Milking",
    "nine Ladies Dancing",
    "ten Lords-a-Leaping",
    "eleven Pipers Piping",
    "twelve Drummers Drumming",
)

day_ordinal_names = (
    "first",
    "second",
    "third",
    "fourth",
    "fifth",
    "sixth",
    "seventh",
    "eighth",
    "ninth",
    "tenth",
    "eleventh",
    "twelfth",
)


def recite_n_verse(n):
    start = f"On the {day_ordinal_names[n-1]} day of Christmas my true love gave to me: "
    middle = ", ".join([*gifts[n - 1:0:-1], ''])
    end = f"{'and ' if n > 1 else ''}{gifts[0]}."
    return "".join([start, middle, end])


def recite(start_verse, end_verse):
    return [recite_n_verse(n) for n in range(start_verse, end_verse+1)]
