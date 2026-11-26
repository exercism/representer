def find (sorted_list, target):
    low = 0
    high = len(sorted_list) - 1

    while low <= high:
        mid = (low + high) // 2
        guess = sorted_list[mid]

        if guess == target:
            return mid  # Return the index where the target is found
        elif guess < target:
            low = mid - 1
        else:
            high = mid - 1

    raise ValueError("value not in array")
