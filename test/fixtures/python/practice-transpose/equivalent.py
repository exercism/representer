def placeholder_0(placeholder_1):
    placeholder_2 = [placeholder_3.replace(' ', '_') for placeholder_3 in placeholder_1.splitlines()]
    placeholder_2 = [placeholder_3.ljust(len(max(placeholder_2, key=len))) for placeholder_3 in placeholder_2]
    placeholder_2 = [''.join(placeholder_3) for placeholder_3 in zip(*placeholder_2)]
    placeholder_2 = [placeholder_3.rstrip().replace('_', ' ') for placeholder_3 in placeholder_2]
    return '\n'.join(placeholder_2)
