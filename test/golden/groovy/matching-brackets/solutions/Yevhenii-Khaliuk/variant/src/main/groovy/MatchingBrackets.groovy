class MatchingBrackets {

    static final BRACKETS_PAIRS = [
            ']': '[',
            ')': '(',
            '}': '{'
    ]

    static isPaired(value) {
        def brackets = []
        for (ch in value) {
            if (ch in ['[', '(', '{']) {
                brackets << ch
            } else if (ch in [']', ')', '}']) {
                if (!brackets.isEmpty() && brackets[-1] != BRACKETS_PAIRS[(ch)]) {
                    brackets.removeLast()
                } else {
                    return false
                }
            }
        }
        brackets.isEmpty()
    }
}
