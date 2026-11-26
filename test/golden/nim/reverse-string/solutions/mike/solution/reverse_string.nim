proc reverse*(text: string): string =
    result = ""
    for i in 1..len(text):
        result.add(text[^i])
