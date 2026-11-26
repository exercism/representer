using System;

static class LogLine
{
    public static string Message(string logLine){
        
        string result = logLine.Substring(logLine.LastIndexOf(':') + 1);
        
        return result.Trim();
        
    }

    public static string LogLevel(string logLine){
        
        int pos1 = logLine.IndexOf('[') + 1;
        int pos2 = logLine.LastIndexOf(']');

        string result = logLine.Substring(pos1, pos2 - pos1);

        return result.ToLower();
            
    }

    public static string Reformat(string logLine){

        string message = logLine.Substring(logLine.LastIndexOf(':') + 1);

        int pos1 = logLine.IndexOf('[') + 1;
        int pos2 = logLine.LastIndexOf(']');
        string result = logLine.Substring(pos1, pos2 - pos1);

        return (@$"{message.Trim()} ({result.ToLower()})"); 
        
    }
}
