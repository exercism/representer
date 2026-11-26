def equilateral(sides):
    return sides[0]==sides[1]==sides[2] and sum(sides)>0


def isosceles(t):
    tri= (sum(t)-t[0] >= t[0]) and (sum(t)-t[1] >= t[1]) and (sum(t)-t[2] >= t[2]) and sum(t)>0
    sides= t[0]==t[1] or t[1]==t[2] or t[0]==t[2]
    return tri and sides 

def scalene(t):
    tri= (sum(t)-t[0] >= t[0]) and (sum(t)-t[1] >= t[1]) and (sum(t)-t[2] >= t[2]) and sum(t)>0
    sides= t[0]!=t[1] and t[1]!=t[2] and t[0]!=t[2]
    return tri and sides