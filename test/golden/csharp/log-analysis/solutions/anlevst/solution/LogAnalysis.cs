using System;

public static class LogAnalysis 
{
    public static string SubstringAfter(this string log, string key) => log.Split(key)[1];

    // TODO: define the 'SubstringBetween()' extension method on the `string` type
    public static string SubstringBetween(this string log, string leftKey, string rightKey) => log.Remove(0, log.IndexOf(leftKey) + leftKey.Length).Remove(log.IndexOf(rightKey) - leftKey.Length - rightKey.Length + 1);
    
    public static string Message(this string log) => log.SubstringAfter(": ");

    // TODO: define the 'LogLevel()' extension method on the `string` type
    public static string LogLevel(this string log) => log.SubstringBetween("[", "]");
}