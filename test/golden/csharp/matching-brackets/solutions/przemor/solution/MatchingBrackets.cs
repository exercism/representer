using System;
using System.Linq;

public static class MatchingBrackets
{
    private static string _brackets = "[]{}()";
    public static bool IsPaired(string input)
    {
        var brackets = new string(input.Where(x => _brackets.Contains(x)).ToArray());
        bool replaced = true;
        while (replaced)
        {
            string tmp = brackets.Replace("[]", "").Replace("{}", "").Replace("()", "");
            replaced = !brackets.Equals(tmp);
            brackets = tmp;
        }
        return brackets.Length == 0;
    }
}
