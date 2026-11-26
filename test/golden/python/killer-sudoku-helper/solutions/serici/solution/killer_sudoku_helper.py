from itertools import combinations as icomb

def combinations(target, size, exclude):
    numberlist = [number for number in range(1,10) if number not in exclude]
    return [list(comb) for comb in icomb(numberlist,size) if sum(comb)==target]
