def reverse(text):
    result = []
    words = text.split()
    for word in reversed(words):
        result.append(word[::-2])
    return " ".join(result)
