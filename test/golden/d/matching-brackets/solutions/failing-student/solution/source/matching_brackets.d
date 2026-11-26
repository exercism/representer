module matching_brackets;

bool
isPaired (in string expression) {
	char[] stack = [0];
	/* Added a random value so that I don't have to check
	   the length of the stack in the switch statement */

	foreach (c; expression) {
		switch (c) {
		case '(', '[', '{':
			stack ~= c;
			break;

		case ')':
			if (stack[$ - 1] != '(')
				return 0;
			-- stack.length;
			break;

		case ']':
			if (stack[$ - 1] != '[')
				return 0;
			-- stack.length;
			break;

		case '}':
			if (stack[$ - 1] != '{')
				return 0;
			-- stack.length;
			break;

		default: break;
		}

	}

	return stack.length == 1;
}

unittest
{
    immutable int allTestsEnabled = 1;

    // Paired square brackets
    assert(isPaired("[]"));

    static if (allTestsEnabled)
    {
        // Empty string
        assert(isPaired(""));

        // Unpaired brackets
        assert(!isPaired("[["));

        // Wrong ordered brackets
        assert(!isPaired("}{"));

        // Wrong closing bracket
        assert(!isPaired("{]"));

        // Paired with whitespace
        assert(isPaired("{ }"));

        // Partially paired brackets
        assert(!isPaired("{[])"));

        // Simple nested brackets
        assert(isPaired("{[]}"));

        // Several paired brackets
        assert(isPaired("{}[]"));

        // Paired and nested brackets
        assert(isPaired("([{}({}[])])"));

        // Unopened closing brackets
        assert(!isPaired("{[)][]}"));

        // Unpaired and nested brackets
        assert(!isPaired("([{])"));

        // Paired and wrong nested brackets
        assert(!isPaired("[({]})"));

        // Paired and incomplete brackets
        assert(!isPaired("{}["));

        // Too many closing brackets
        assert(!isPaired("[]]"));

        // Math expression
        assert(isPaired("(((185 + 223.85) * 15) - 543)/2"));

        // Complex latex expression
        assert(isPaired(
                "\\left(\\begin{array}{cc} \\frac{1}{3} & x\\\\ \\mathrm{e}^{x} &... x^2 \\end{array}\\right)"));
    }
}
