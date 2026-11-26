using System;

public static class LogAnalysis 
{
    public static string SubstringAfter(this string str, string input )
    {
        int index = str.IndexOf(input) + input.Length ;
        return str.Substring(index, str.Length - index);
    }


    public static string SubstringBetween(this string str, string start, string end)
    {
        int startIndex = str.IndexOf(start) + start.Length ;
        int endIndex = str.IndexOf( end ) - (str.IndexOf(start) - start.Length) ;
        string result = str.Substring(startIndex, endIndex);
        return result;
    }

    public static string Message(this string str)
    {

        return str.SubstringAfter(": ");
    }
 public static string LogLevel(this string str)
    {
        return str.SubstringBetween( "[", "]" );
    }
}