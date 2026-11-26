def distance(strand_a, strand_b):
    count = 0
    if len(strand_a) != len(strand_b):
        raise ValueError("Strands must be of equal length.")
    else:
        for index,ele_a in enumerate(strand_a):
                if ele_a != strand_b[index]:
                    count += 1
                else:
                    continue
    return count
        
