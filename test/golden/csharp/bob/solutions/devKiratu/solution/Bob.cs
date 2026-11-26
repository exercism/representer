using System;

public static class Bob
{
    public static string Response(string statement)
    {
        return statement switch
        {
            _ when string.IsNullOrWhiteSpace(statement) => "Fine. Be that way!",
            _ when IsYellingQuestion(statement) => "Calm down, I know what I'm doing!",
            _ when IsYelling(statement) => "Whoa, chill out!",
            _ when IsQuestion(statement) => "Sure.",
            _ => "Whatever."

        };
    }
    private static bool IsYellingQuestion(string s)
    {
        return IsYelling(s) && IsQuestion(s);
    }

    private static bool IsQuestion(string s)
    {
        return s.TrimEnd().EndsWith('?');
    }

    private static bool IsYelling(string s)
    {
        return s != s.ToLower() && s == s.ToUpper();
    }
}