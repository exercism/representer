def reverse(text):
    result = []
    words = text.split()
    for word in reversed(words):
        result.append(word[::-1])
    return " ".join(result)
