import logging
from collections import defaultdict, Counter
placeholder_0 = lambda placeholder_1: 50 if len(set(placeholder_1)) == 1 else 0
placeholder_2 = lambda placeholder_1: sum((placeholder_3 for placeholder_3 in placeholder_1 if placeholder_3 == 1))
placeholder_4 = lambda placeholder_1: sum((placeholder_3 for placeholder_3 in placeholder_1 if placeholder_3 == 2))
placeholder_5 = lambda placeholder_1: sum((placeholder_3 for placeholder_3 in placeholder_1 if placeholder_3 == 3))
placeholder_6 = lambda placeholder_1: sum((placeholder_3 for placeholder_3 in placeholder_1 if placeholder_3 == 4))
placeholder_7 = lambda placeholder_1: sum((placeholder_3 for placeholder_3 in placeholder_1 if placeholder_3 == 5))
placeholder_8 = lambda placeholder_1: sum((placeholder_3 for placeholder_3 in placeholder_1 if placeholder_3 == 6))
placeholder_9 = lambda placeholder_1: sum(placeholder_1) if len(set(placeholder_1)) == 2 and any((placeholder_1.count(placeholder_3) == 3 for placeholder_3 in set(placeholder_1))) else 0
placeholder_10 = lambda placeholder_1: sum((placeholder_3 * 4 for placeholder_3 in set(placeholder_1) if placeholder_1.count(placeholder_3) > 3))
placeholder_11 = lambda placeholder_1: 30 if sum(placeholder_1) == 15 and len(set(placeholder_1)) == 5 else 0
placeholder_12 = lambda placeholder_1: 30 if sum(placeholder_1) == 20 and len(set(placeholder_1)) == 5 else 0
placeholder_13 = lambda placeholder_1: sum(placeholder_1)

def placeholder_14(placeholder_15, placeholder_16):
    if any((not 0 < placeholder_3 < 7 for placeholder_3 in placeholder_15)):
        raise ValueError('Invalid dice {}'.format(placeholder_15))
    return placeholder_16(placeholder_15)

def placeholder_17(placeholder_18):
    """
    Generate a list of formatted report strings for tournament results.

     >>> test = (tally(["Courageous Californians;Devastating Donkeys;win",                        "Allegoric Alaskans;Blithering Badgers;win",                        "Devastating Donkeys;Allegoric Alaskans;loss",                        "Courageous Californians;Blithering Badgers;win",                        "Blithering Badgers;Devastating Donkeys;draw",                        "Allegoric Alaskans;Courageous Californians;draw"]))
     >>> print(type(test))
     <class 'list'>
     >>> print(test[0])
     Team                           | MP |  W |  D |  L |  P
     >>> print(test[1])
     Allegoric Alaskans             |  3 |  2 |  1 |  0 |  7
     >>> print(test[2])
     Courageous Californians        |  3 |  2 |  1 |  0 |  7
     >>> print(test[3])
     Blithering Badgers             |  3 |  0 |  1 |  2 |  1
     >>> print(test[4])
     Devastating Donkeys            |  3 |  0 |  1 |  2 |  1
    """
    try:
        placeholder_19 = (placeholder_20.split(';') for placeholder_20 in placeholder_18)
        placeholder_21 = placeholder_22(placeholder_19)
    except AttributeError:
        logger.exception(f'There is a problem with the tournament results string: ')
        raise
    except IndexError:
        logger.exception(f'Compiling team statistics failed: ')
        raise
    return placeholder_28(placeholder_21)

def placeholder_22(placeholder_19):
    """
    Create a stats dictionary with results by team name.
    Return a dictionary with Counter()s as values.
    """
    placeholder_23 = defaultdict(Counter)
    placeholder_24 = {'win': 'loss', 'loss': 'win', 'draw': 'draw'}
    for placeholder_25, placeholder_26, placeholder_27 in placeholder_19:
        placeholder_23[placeholder_25].update([placeholder_27])
        placeholder_23[placeholder_26].update([placeholder_24[placeholder_27]])
    return placeholder_23

def placeholder_28(placeholder_23):
    """
    Format & return a report string for printing.
    If there are no team_stats, return only a header.
    """
    placeholder_29 = '{:<30} | {:4>} |  {:4>} |  {:4>} |  {:4>} | {:>2}'
    placeholder_30 = [('Team', 'MP', 'W', 'D', 'L', 'P')]
    placeholder_31 = ((placeholder_32, ' ' + str(sum(placeholder_23[placeholder_32].values())), placeholder_23[placeholder_32]['win'], placeholder_23[placeholder_32]['draw'], placeholder_23[placeholder_32]['loss'], placeholder_23[placeholder_32]['win'] * 3 + placeholder_23[placeholder_32]['draw']) for placeholder_32 in placeholder_23.keys())
    placeholder_33 = placeholder_30 + sorted(placeholder_31, key=lambda placeholder_3: (-placeholder_3[5], placeholder_3))
    return '\n'.join((placeholder_29.format(*placeholder_32) for placeholder_32 in placeholder_33)).split('\n')
