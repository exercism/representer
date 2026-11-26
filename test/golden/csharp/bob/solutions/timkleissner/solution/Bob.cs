using System;

public static class Bob
{
    private static readonly char[] shouting = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
    private static readonly char[] scream = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};

    public static string Response(string statement) =>
        statement.IndexOf("?")==statement.TrimEnd().Length-1 && statement.TrimEnd() != "" ?
        statement.IndexOfAny(shouting)==-1 && statement.IndexOfAny(scream)!=-1 ?
        "Calm down, I know what I'm doing!" : "Sure." :
        statement.IndexOfAny(shouting)==-1 && statement.IndexOfAny(scream)!=-1 ?
        "Whoa, chill out!" : statement.TrimStart() == "" ?
        "Fine. Be that way!" : "Whatever.";
}