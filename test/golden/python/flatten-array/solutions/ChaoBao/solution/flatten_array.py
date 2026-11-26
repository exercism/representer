def flatten(iterable):
    flat_list = []
    word = str(iterable)
    word = word.replace("[", "").replace("]", "").replace(" ", "").replace("None", "")
    flat = list(word.split(","))
    for number in flat:
        if number == "":
            continue
        else:
            flat_list.append(int(number))
    return flat_list