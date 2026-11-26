proc reverse*(s: string): string =
    for i, _ in s:
        result.add(s[s.high - i])