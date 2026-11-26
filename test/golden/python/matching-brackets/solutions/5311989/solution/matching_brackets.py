def is_paired(input_string):
    matching = {'{':'}','[':']','(':')'}
    stack = []
    for c in input_string:
        if c in matching.keys():
            stack.append(c)
        if c in matching.values():
            if not stack or c != matching[stack[-1]]:
                return False
            stack.pop()
    return not stack
