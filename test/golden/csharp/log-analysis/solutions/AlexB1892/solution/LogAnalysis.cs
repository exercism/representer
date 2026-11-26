using System;

public static class LogAnalysis
{
    public static string SubstringAfter(this string message, string delimeter)
    {
        return message.Split(delimeter)[1];
    }

    public static string SubstringBetween(this string message, string delimiter1, string delimiter2)
    {
        return message.Split(delimiter1)[1].Split(delimiter2)[0];
    }

    public static string Message(this string message)
    {
        return message.SubstringAfter(": ");
    }

    public static string LogLevel(this string message)
    {
        return message.SubstringBetween("[", "]");
    }
}