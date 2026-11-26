def maximum_value(max_weight: int, items: list[dict[str, int]]) -> int:
    """Return maximum possible value stolen from house in knapsack."""
    w_v_combos = [(0, 0)]
    # Build list of summed weights/values for possible combinations of items.
    for item in items:
        w_v_combos += [
            (w + item['weight'], v + item['value'])
            for w, v in w_v_combos
        ]
    return max(v for w, v in w_v_combos if w <= max_weight)