using System;
using System.Linq;
using System.Text.RegularExpressions;

public static class Bob
{
    public static string Response(string statement)
    {
        return new Regex(@"^$|^\s+$|([\t]+|[\r]+)").IsMatch(statement)
            ? "Fine. Be that way!"
            : IsAllCapitals(statement) && IsQuestion(statement)
            ? "Calm down, I know what I'm doing!"
            : IsQuestion(statement)
            ? "Sure."
            : IsAllCapitals(statement)
            ? "Whoa, chill out!"
            : "Whatever.";

        bool IsQuestion(string st) => st.TrimEnd()[^1] == '?';

        bool IsAllCapitals(string st)
        {
            var s = st.Where(c => new Regex("[A-Za-z]").IsMatch(c.ToString()));
            return s.Count() > 1 && s.All(char.IsUpper);
        }
    }
}