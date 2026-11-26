using System;
using System.Linq;

static class LogLine
{
    public static string Message(string logLine)
    {
        return logLine
            .Split(":")
            .Skip(1)
            .FirstOrDefault()
            .Trim();
    }

    public static string LogLevel(string logLine)
    {
        return logLine
            .Split(":")
            .FirstOrDefault()
            .Trim()
            .Replace("[","")
            .Replace("]","")
            .ToLower();
    }

    public static string Reformat(string logLine)
    {
        var level = LogLevel(logLine);
        var message = Message(logLine);
        return $"{message} ({level})";
    }
}
