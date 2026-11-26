using System.Linq;

public static class Bob
{
    public static string Response(string statement) =>
        statement.Trim() switch
        {
            var s when s.EndsWith('?') && s.ToUpper() == s && s.Any(char.IsLetter) => "Calm down, I know what I'm doing!",
            var s when s.ToUpper() == s && s.Any(char.IsLetter) => "Whoa, chill out!",
            var s when s.EndsWith('?') => "Sure.",
            "" => "Fine. Be that way!",
            _ => "Whatever."
        };
}