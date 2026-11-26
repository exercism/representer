const bracketsMap: { [index: string]: string } = {
    "(": ")",
    "[": "]",
    "{": "}",
} as const;

export function isPaired(input: string): boolean {
    const brackets: string[] = [];
    for (const ch of input) {
        if (Object.keys(bracketsMap).includes(ch)) {
            brackets.push(ch);
        } else if (Object.values(bracketsMap).includes(ch)) {
            if (
                brackets.length === 0 &&
                brackets.pop() !==
                    Object.keys(bracketsMap).find(
                        (key) => bracketsMap[key] === ch
                    )
            )
                return false;
        }
    }
    return brackets.length === 0;
}
