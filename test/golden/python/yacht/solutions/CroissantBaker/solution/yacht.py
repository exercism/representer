# Score categories.
# Change the values as you see fit.
YACHT = 0
ONES = 1
TWOS = 2
THREES = 3
FOURS = 4
FIVES = 5
SIXES = 6
FULL_HOUSE = 7
FOUR_OF_A_KIND = 8
LITTLE_STRAIGHT = 9
BIG_STRAIGHT = 10
CHOICE = 11


        

def score(dice, category):
    counts = [0] * 6
    for n in dice:
        counts[n-1] += 1
    
    if category == YACHT:
        for n in counts:
            if n == 5:
                return 50        
        return 0
    elif ONES <= category and category <= SIXES:
        return counts[category - 1] * (category)
    elif category == FULL_HOUSE:
        mults = 1
        for x in counts:
            if x != 0:
                mults *= x
        if mults == 6:
            return sum([(i+1)*x for (i,x) in enumerate(counts)])
        else:
            return 0
    elif category == FOUR_OF_A_KIND:
        for (i,x) in enumerate(counts):
            if x >= 4:
                return (i+1) * 4
        return 0
    elif category == LITTLE_STRAIGHT:
        if counts[0] == 1 and counts[1] == 1 and counts[2] == 1 and counts[3] == 1 and counts[4] == 1:
            return 30
        else:
            return 0
    elif category == BIG_STRAIGHT:
        if counts[1] == 1 and counts[2] == 1 and counts[3] == 1 and counts[4] == 1 and counts[5] == 1:
            return 30
        else:
            return 0
    elif category == CHOICE:
        return sum([(i+1)*x for (i,x) in enumerate(counts)])
        
