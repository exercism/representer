.name,
(.ingredients | length),
(.ingredients | map(select(.item == "sugar") | .amount.quantity)[0]),
(.ingredients + ."optional ingredients" | map(select(.substitute) | {(.item): .substitute}) | add)