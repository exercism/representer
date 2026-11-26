def value(colors):
    bands = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'grey', 'white']
    output_list = []

    for index, i in enumerate(colors):
        if index >= 1:
            break
        else:
            output_list.append(str(bands.index(i)))
        
    output = int(''.join(output_list))
    return output