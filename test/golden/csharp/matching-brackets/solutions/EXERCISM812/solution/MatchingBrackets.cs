public static class MatchingBrackets
{
    public static bool IsPaired(string input)
    {
        var stack = new Stack<char>();
        var brackets = new Dictionary<char, char> { { '[', ']' }, { '(', ')' }, { '{', '}' } };
        foreach (var c in input)
        {
            if (brackets.ContainsKey(c)) stack.Push(c);
            else if (brackets.ContainsValue(c)) if (stack.Count == 0 || brackets[stack.Pop()] != c) return false; 
        }
        return stack.Count == 0;
    }
}