using System;

public static class ReverseString
{
    public static string Reverse(string input)
    {
        char[] inputChar = input.ToCharArray();  
        char[] outputChar = new char[input.Length];
        int i = 0;
        
        foreach(char bokstav in inputChar)
        {
            outputChar[i] = inputChar[input.Length - 1 - i];
            i++;
        }
        string output = new string(outputChar);
        return output;
    }
}