def placeholder_0(placeholder_1):
    if not placeholder_1:
        return []
    if any((len(placeholder_2) != len(placeholder_1[0]) for placeholder_2 in placeholder_1)):
        raise ValueError('irregular matrix')
    placeholder_3 = [max(placeholder_2) for placeholder_2 in placeholder_1]
    placeholder_4 = [min(placeholder_5) for placeholder_5 in zip(*placeholder_1)]
    placeholder_6 = [{'row': placeholder_7 + 1, 'column': placeholder_9 + 1} for placeholder_7, _ in enumerate(placeholder_1) for placeholder_9, _ in enumerate(placeholder_1[0]) if placeholder_3[placeholder_7] == placeholder_4[placeholder_9]]
    return placeholder_6 or []
