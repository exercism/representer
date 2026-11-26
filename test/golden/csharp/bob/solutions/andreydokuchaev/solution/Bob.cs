using System;
using System.Linq;

public static class Bob
{
    public static string Response(string statement)
    {    
        if (string.IsNullOrWhiteSpace(statement))
            return "Fine. Be that way!";
        if (statement.ToUpper() == statement && statement.Any(char.IsLetter)) {
            if (statement.Trim().EndsWith('?'))
                return "Calm down, I know what I'm doing!";
            else
                return "Whoa, chill out!";
        }
        else {
            if (statement.Trim().EndsWith('?'))
                return "Sure.";
        }
        return "Whatever."; 
    }
}