placeholder_0 = [('lay in', 'the house that Jack built.'), ('ate', 'the malt'), ('killed', 'the rat'), ('worried', 'the cat'), ('tossed', 'the dog'), ('milked', 'the cow with the crumpled horn'), ('kissed', 'the maiden all forlorn'), ('married', 'the man all tattered and torn'), ('woke', 'the priest all shaven and shorn'), ('kept', 'the rooster that crowed in the morn'), ('belonged to', 'the farmer sowing his corn'), ('', 'the horse and the hound and the horn')]

def placeholder_1(placeholder_2):
    placeholder_1 = [f'This is {placeholder_0[placeholder_2][1]}']
    placeholder_1.extend(['that {0} {1}'.format(*placeholder_0[placeholder_3]) for placeholder_3 in range(placeholder_2 - 1, -1, -1)])
    return ' '.join(placeholder_1)

def placeholder_4(placeholder_5, placeholder_6):
    return [placeholder_1(placeholder_2) for placeholder_2 in range(placeholder_5 - 1, placeholder_6)]
