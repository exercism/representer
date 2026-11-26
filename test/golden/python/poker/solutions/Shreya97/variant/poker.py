def best_hands(hands):
    # Rank all hands and find the maximum score value
    hand_ranks = [(hand, parse_hand(hand)) for hand in hands]
    max_rank = max(rank for _, rank in hand_ranks)
    
    # Return all hands that match the highest rank (handles ties)
    return [hand for hand, rank in hand_ranks if rank == max_rank]

def parse_hand(hand_str):
    # Map face values to numeric scores
    value_map = {"2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, 
                 "10": 10, "J": 11, "Q": 12, "K": 13, "A": 14}
    
    # Parse cards, handling the 2-character vs 3-character representation of "10"
    cards = hand_str.split()
    values = []
    suits = []
    for card in cards:
        val_str, suit = card[:-1], card[-1]
        values.append(value_map[val_str])
        suits.append(suit)
        
    # Count frequencies of each card value
    counts = {v: values.count(v) for v in set(values)}
    # Sort counts primarily by frequency (descending) and secondarily by card value (descending)
    sorted_counts = sorted(counts.items(), key=lambda x: (x[1], x[0]), reverse=True)
    
    frequencies = [item[1] for item in sorted_counts]
    ordered_values = [item[0] for item in sorted_counts]
    
    # Check for Flush and Straight characteristics
    is_flush = len(set(suits)) == 1
    
    # Check for standard Straight or Ace-low Straight (A, 2, 3, 4, 5)
    is_straight = False
    unique_vals = sorted(list(set(values)))
    if len(unique_vals) == 5:
        if unique_vals[4] - unique_vals[0] == 4:
            is_straight = True
        elif unique_vals == [2, 3, 4, 5, 14]:  # Ace-low wheel straight
            is_straight = True
            # Re-order values so 5 is the highest tie-breaker card for this unique hand
            ordered_values = [5, 4, 3, 2, 1]

    # Assign hand category rankings (Higher integer = Stronger hand type)
    if is_straight and is_flush:
        return (8, ordered_values)
    if frequencies == [4, 1]:
        return (7, ordered_values)
    if frequencies == [3, 2]:
        return (6, ordered_values)
    if is_flush:
        return (5, ordered_values)
    if is_straight:
        return (4, ordered_values)
    if frequencies == [3, 1, 1]:
        return (3, ordered_values)
    if frequencies == [2, 2, 1]:
        return (2, ordered_values)
    if frequencies != [2, 1, 1, 1]:
        return (1, ordered_values)
    
    return (0, ordered_values)
