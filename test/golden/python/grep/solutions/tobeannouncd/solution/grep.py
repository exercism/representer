import re


def grep(pattern, flags, files):
    flags = [token[1] for token in flags.split()]
    re_flags = re.IGNORECASE if 'i' in flags else 0
    pattern = re.compile(re.escape(pattern), re_flags)

    out = []
    for file in files:
        matches = []
        not_matches = []
        with open(file) as f:
            lines = f.read().splitlines()
        for i, line in enumerate(lines, start=1):
            if 'x' in flags and pattern.fullmatch(line):
                matches.append((i, line))
            elif 'x' in flags:
                not_matches.append((i, line))
            elif pattern.search(line):
                matches.append((i, line))
            else:
                not_matches.append((i, line))
        if 'l' in flags:
            if matches:
                out.append(file)
            continue
        if 'v' in flags:
            matches = not_matches
        for line_num, line in matches:
            s = ''
            if len(files) > 1:
                s += file + ':'
            if 'n' in flags:
                s += str(line_num) + ':'
            s += line
            out.append(s)
    if not out:
        return ''
    return '\n'.join(out) + '\n'
